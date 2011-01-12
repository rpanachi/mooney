class UserSessionsController < ApplicationController

  layout "default"

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:destroy]

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Bem vindo!"
      redirect_back_or_default overview_path
    else
      if @user_session.errors.on(:base).to_a.find {|a| a.include?(I18n.t("authlogic.error_messages.not_active"))}
        @user_session.errors.clear
        flash[:error] = "Sua conta ainda não foi ativada! Verifique as instruções em seu email ou solicite um novo código de ativação <a href=\"#{passwords_path}\">clicando aqui</a>."
        redirect_to :action => :new
      else
        render :action => :new
      end
    end
  end

  def destroy
    current_user_session.destroy if current_user_session
    redirect_to root_url
  end
end
