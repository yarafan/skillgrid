class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:show, :index]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    render "new_#{params[:role]}"
  end

  # GET /users/1/edit
  def edit
    render "edit_#{params[:role]}"
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.send("#{params[:role]}=", true)
    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render "new_#{params[:role]}"
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  def change_role
    user = User.find(params[:id])
    User::ROLES.each { |role| user.update_column("#{role}", false) }
    user.update_column("#{params[:role]}", true)
    redirect_to users_path
  end

  private

  def check_admin
    redirect_to products_path unless current_user.try(:admin)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :pass_hash, :pass_salt,
                                 :password, :password_confirmation, :avatar, :photo, :shop, :birthday, :surname)
  end
end
