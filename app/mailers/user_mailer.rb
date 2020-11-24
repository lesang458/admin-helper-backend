class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Password reset'
  end

  def employee_request(request, subject)
    @day_off_request = request
    send_mail_to_admin(subject)
  end

  def send_mail_to_admin(subject)
    emails = User.where('roles @> ?', '{ADMIN}').map(&:email)
    mail to: emails, subject: subject
  end

  def admin_request(request, subject)
    @day_off_request = request
    send_mail_to_user(@day_off_request.user.email, subject)
  end

  def send_mail_to_user(email, subject)
    mail to: email, subject: subject
  end
end
