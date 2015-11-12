class MailSender < ApplicationMailer
  default from: 'no-reply@mail.com'

  def buy_success(user, product)
    @user = user
    @product = product
    mail(to: user.email)
  end

  def mail_admins(id)
    @id = id
    User.where(admin: true).each { |admin| mail(to: admin.email) }
  end

  def report_admins(email)
    @email = email
    User.where(admin: true).each { |admin| mail(to: admin.email) }
  end
end
