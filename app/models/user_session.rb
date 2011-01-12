class UserSession < Authlogic::Session::Base

  generalize_credentials_error_messages true #I18n.translate :email_password_invalid

end
