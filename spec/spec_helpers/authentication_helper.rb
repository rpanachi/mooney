module AuthenticationHelper

  protected
  
  def login_as_user
    post login_path, :user_session => valid_user_session_attributes
  end

  def valid_user_session_attributes
    @valid_user_session_attributes ||= {:email => "admin@server.com", :password => "123456"}
  end

end
