class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  has_many :products, dependent: :destroy
  has_attached_file :photo, styles: { thumb: '100x100', large: '500x500' }
  has_attached_file :avatar, styles: { thumb: '100x100', large: '500x500' }

  # TODO
  # Incorporate Paperclip validations to roles validators
  validates_attachment :avatar, presence: true, content_type: { content_type: /\Aimage/ }
  validates_attachment :photo, presence: true, content_type: { content_type: /\Aimage/ }

  before_save :encrypt
  enum role: [:guest, :owner, :admin]

  def encrypt
    salt = self.pass_salt = BCrypt::Engine.generate_salt
    self.pass_hash = BCrypt::Engine.hash_secret(password, salt) if password
  end

  def self.admin_emails
    User.where(role: User.roles[:admin]).pluck(:email)
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
