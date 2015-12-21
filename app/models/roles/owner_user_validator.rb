module Roles
  class OwnerUserValidator < SimpleDelegator
    include ActiveModel::Validations

    ATTRIBUTES = [:shop, :email, :password]

    ATTRIBUTES.each do |attr|
      delegate attr, :errors, to: :user
    end

    validates :shop, presence: true
    validates :email, presence: true
    validates :password, presence: true, length: { minimum: 8 }

    def initialize(user)
      @user = user
    end

    private

    attr_reader :user
  end
end
