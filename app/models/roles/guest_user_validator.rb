module Roles
  class GuestUserValidator < SimpleDelegator
    include ActiveModel::Validations

    ATTRIBUTES = [:email, :password]

    ATTRIBUTES.each do |attr|
      delegate attr, :errors, to: :user
    end

    validates :email, presence: true
    validates :password, presence: true, length: { minimum: 6 }

    def initialize(user)
      @user = user
    end

    private

    attr_reader :user
  end
end
