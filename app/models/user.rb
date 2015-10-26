class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation
  before_save :encrypt

  def encrypt
    salt = self.pass_salt = BCrypt::Engine.generate_salt
    self.pass_hash = BCrypt::Engine.hash_secret(password, salt) if password
  end
end
