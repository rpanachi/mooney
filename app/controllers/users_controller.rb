require "csv"

class UsersController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create, :activate]
  before_filter :require_user, :only => [:show, :edit, :update, :destroy, :confirm_destroy, :confirm_export, :export]

  layout "default"

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save_without_session_maintenance
      flash[:notice] = "Usuário cadastrado com sucesso!\nAtive sua conta seguindo as instruções\nque enviamos agora mesmo para seu email."
      redirect_to login_url
    else
      render :action => :new
    end
  end

  def activate
    if @user = User.find_using_perishable_token(params[:token])
        
      @user.activate!
      UserSession.new(@user).save

      flash[:notice] = "Seu cadastro foi ativado. Comece a controlar seu dinheiro agora mesmo!"
      redirect_to overview_path
    else
      flash[:error] = "Não foi possível ativar sua conta: código inválido ou conta expirada!"
      render :invalid
    end
  end

  def edit
    @user = @current_user
    render :layout => "application"
  end

  def update
    @user = @current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Suas informações foram atualizadas!"
      redirect_to edit_user_url(@user)
    else
      render :action => :edit, :layout => "application"
    end
  end

  def confirm_export
    render :export, :layout => "application"
  end

  def export

    @entries = Entry.from_user(current_user).all
  
    report = StringIO.new
    CSV::Writer.generate(report, ';') do |csv|
      csv << ['ID', 'CONTA', 'CATEGORIA', 'DESCRICAO', 'DATA', 'VALOR', 'PAGO']
      @entries.each do |entry|
        record = [entry.id]
        record << (entry.account.name.gsub(";", "") rescue '')
        record << (entry.category.name.gsub(";", "") rescue '')
        record << (entry.description.gsub(";", "") rescue '')
        record << (l(entry.date, :format => '%d/%m/%Y') rescue '')
        record << (entry.value.to_f rescue '')
        record << (entry.paid ? 'S' : 'N')
        csv << record
      end
    end
    report.rewind
    send_data report.read, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=entries.csv"

  end

  def confirm_destroy
    @user = @current_user
    render "destroy", :layout => "application"
  end

  def destroy
    @user = @current_user
    if "#{params[:comments]}".size >= 20
      @user.destroy
      Mailer.deliver_admin_user_destroyed(@user, params[:comments])
      
      flash[:notice] = "Sua conta foi excluída. Até logo!"
      redirect_to login_path
    else
      @user.errors.add_to_base("Por favor, forneça alguma informação que possa nos ajudar a melhorar este serviço")
      render "destroy", :layout => "application"
    end
  end
  
end
