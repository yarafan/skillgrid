class AdminSender < ApplicationMailer
  default from: 'no-reply@mail.com', to: proc { User.admin_emails }

  def mail_admins(id)
    @id = id
    mail(subject: 'Purchase complete')
  end

  def report_admins(email)
    @email = email
    mail(subject: 'Error occured')
  end
end
