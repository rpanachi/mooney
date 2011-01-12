class ApplicationController < ActionController::Base

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper :all
  helper_method :current_user_session, :current_user

  filter_parameter_logging :password, :password_confirmation

  before_filter :application_defaults

  private

  def logged_user?
    !!current_user
  end

  def application_defaults
    @accounts = Account.from_user(current_user).all if logged_user?
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "Você precisa fazer o login para acessar esta página"
      redirect_to login_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "Você precisa fazer o logout para acessar esta página"
      redirect_to overview_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
