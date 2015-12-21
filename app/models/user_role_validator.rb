class UserRoleValidator
  attr_reader :validator

  def initialize(user)
    role = user.role.to_sym
    @validator = case role
                 when :admin
                   Roles::AdminUserValidator.new(user)
                 when :owner
                   Roles::OwnerUserValidator.new(user)
                 when :guest
                   Roles::GuestUserValidator.new(user)
                 end
  end
end
