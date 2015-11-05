module ApplicationHelper
  def current_user
    User.find(session[:user_id])
  rescue ActiveRecord::RecordNotFound
    return nil
  end

  def current_user?(user)
    user.id == User.find(session[:user_id]).id
  end
end
