class UserPasswordsController < ApplicationController

  before_filter :require_no_user
  layout "default"

  # GET /passwords
  def index
    flash.now[:notice] = "Informe seu email para receber as instruções<br/> de reativação de sua conta"
    render :action => :new
  end

  # GET /passwords/new
  def new
    @user = User.new
  end

  # POST /passwords
  def create
    if @user = User.find_by_email(params[:email])
      if @user.active?
        @user.send_password_reset_instructions
        flash[:notice] = "Enviamos as instruções para que você cadastre uma nova senha.\nPor favor, verifique sua caixa de emails."
      elsif
        @user.send_activation_instructions
        flash[:notice] = "Sua conta ainda não foi ativada!\nAtive sua conta seguindo as instruções\nque enviamos agora mesmo para seu email."
      end
      redirect_to login_url
    else
      flash[:error] = "Nenhum usuário encontrado com o email informado."
      redirect_to :action => :new
    end
  end

  # GET /passwords/:id
  def show
    redirect_to :action => :edit
  end

  # GET /passwords/:id/edit
  def edit
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = "Usuário não encontrado! Verifique as instruções em seu email ou solicite um novo código de ativação <a href=\"#{passwords_path}\">clicando aqui</a>"
      redirect_to login_url
    end
  end

  # PUT /passwords/:id
  def update
    @user = User.find(params[:id])
    @user.password = params[:password].blank? ? "x" :  params[:password]
    @user.password_confirmation = params[:password_confirmation].blank? ? "x" :  params[:password_confirmation]
    if @user.save_without_session_maintenance
      flash[:notice] = "Senha atualizada com sucesso! Por favor faça o login."
      redirect_to login_url
    else
      render :edit
    end
  end

end
