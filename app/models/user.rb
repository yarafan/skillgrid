class User < ActiveRecord::Base
  enum role: [:guest, :owner, :admin]
  attr_accessor :password, :password_confirmation
  before_save :encrypt

  has_many :products, dependent: :destroy
  has_attached_file :photo, styles: { thumb: '100x100', large: '500x500' }
  has_attached_file :avatar, styles: { thumb: '100x100', large: '500x500' }

  # with_options if: :admin? do |admin|
  #   admin.validates :name, presence: true
  #   admin.validates :surname, presence: true
  #   admin.validates :email, presence: true
  #   admin.validates :password, presence: true, length: { minimum: 10 }
  #   admin.validates :birthday, presence: true
  #   admin.validates_attachment :avatar, presence: true, content_type: { content_type: /\Aimage/ }
  #   admin.validates_attachment :photo, presence: true, content_type: { content_type: /\Aimage/ }
  # end

  # with_options if: :owner? do |owner|
  #   owner.validates :shop, presence: true
  #   owner.validates :email, presence: true
  #   owner.validates :password, presence: true, length: { minimum: 8 }
  #   owner.validates_attachment :avatar, presence: true, content_type: { content_type: /\Aimage/ }
  # end

  # with_options if: :guest? do |guest|
  #   guest.validates :email, presence: true
  #   guest.validates :password, presence: true, length: { minimum: 6 }
  # end

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
