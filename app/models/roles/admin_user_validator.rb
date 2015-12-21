module Roles
  class AdminUserValidator < SimpleDelegator
    include ActiveModel::Validations

    ATTRIBUTES = [:name, :surname, :email, :password, :birthday]

    ATTRIBUTES.each do |attr|
      delegate attr, :errors, to: :user
    end

    validates :name, presence: true
    validates :surname, presence: true
    validates :email, presence: true
    validates :password, presence: true, length: { minimum: 10 }
    validates :birthday, presence: true

    def initialize(user)
      @user = user
    end

    private

    attr_reader :user
  end
end
