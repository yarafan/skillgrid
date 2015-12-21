class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :change_role]
  before_action :check_admin, only: [:show, :index]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
    render "new_#{params[:role]}"
  end

  def edit
    render "edit_#{params[:role]}"
  end

  def create
    @user = User.new(user_params)
    @user.role = params[:role]
    validator = UserRoleValidator.new(@user).validator
    if validator.valid?
      @user.save!(validate: false)
      redirect_to @user, notice: 'User was successfully created.'
    else
      render "new_#{params[:role]}"
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  def change_role
    @user.role = params[:role]
    @user.save!
    redirect_to users_path
  end

  private

  def check_admin
    redirect_to products_path unless current_user.try(:admin?)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :pass_hash, :pass_salt,
                                 :password, :password_confirmation, :avatar, :photo, :shop, :birthday, :surname)
  end
end
