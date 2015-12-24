class UserSender < ApplicationMailer
  default from: 'no-reply@mail.com'

  def buy_success(user, product)
    @user = user
    @product = product
    mail(to: user.email)
  end
end
