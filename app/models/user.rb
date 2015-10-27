class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation
  before_save :encrypt

  validates :name, presence: true, length: { minimum: 5 }
  validates :email, presence: true, format: { with: /[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+\.[a-zA-Z]+{2,4}/, message: 'has invalid format' }
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def encrypt
    salt = self.pass_salt = BCrypt::Engine.generate_salt
    self.pass_hash = BCrypt::Engine.hash_secret(password, salt) if password
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.pass_hash == BCrypt::Engine.hash_secret(password, user.pass_salt)
      user
    else
      false
    end
  end
end
