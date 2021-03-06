class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Password reset'
  end

  def notify_admins(request, subject)
    @day_off_request = request
    emails = User.where('roles @> ?', '{ADMIN}').map(&:email)
    send_mail(emails, subject)
  end

  def notify_requested_employee(request, subject)
    @day_off_request = request
    send_mail(@day_off_request.user.email, subject)
  end

  def send_mail(emails, subject)
    mail to: emails, subject: subject
  end
end
