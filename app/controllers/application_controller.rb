class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    User.find(session[:user_id])
  rescue ActiveRecord::RecordNotFound
    return nil
  end

  def current_user?(user)
    user == current_user
  end
end
