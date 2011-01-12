class Mailer < ActionMailer::Base

  def activation_instructions(user)
    subject    '[Mooney] Ativação de usuário'
    recipients user.email
    from       'mooney@1up4dev.com'
    sent_on    Time.now
    body       :link => activation_url(:token => user.perishable_token)
  end

  def password_reset_instructions(user)
    subject    '[Mooney] Alteração de senha'
    recipients user.email
    from       'mooney@1up4dev.com'
    sent_on    Time.now
    body       :link => password_url(:id => user.perishable_token)
  end

  def admin_user_activated(user)
    subject    '[Mooney] Novo usuário cadastrado'
    recipients 'admin@1up4dev.com'
    from       'mooney@1up4dev.com'
    sent_on    Time.now
    body       :user => user
  end  

  def admin_user_destroyed(user, comments)
    subject    '[Mooney] Usuário excluiu sua conta'
    recipients 'admin@1up4dev.com'
    from       'mooney@1up4dev.com'
    sent_on    Time.now
    body       :email => user.email, :comments => comments
  end  

  def internal_communication(options)

    if !options.include?(:recipients) || !options.include?(:subject) || !options.include?(:body)
      raise "invalid options required: {:recipients => ['email1', 'email2'], :subject => 'assunto', :body => 'information message'}"
    end

    subject    "[Mooney] #{options[:subject]}"
    recipients 'mooney@1up4dev.com'
    bcc        options[:recipients]
    from       'mooney@1up4dev.com'
    sent_on    Time.now
    body       :body => options[:body]
  end

end
