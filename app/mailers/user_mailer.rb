class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Password reset'
  end

  def cancel_request(request)
    @day_off_request = request
    send_mail_to_admin
  end

  def send_mail_to_admin
    emails = User.where('roles @> ?', '{ADMIN}').map(&:email)
    mail to: emails, subject: 'User cancelled request'
  end
end
