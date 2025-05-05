class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  before_action :authenticate_user
  helper_method :current_user, :user_signed_in?

  private

  def authenticate_user
    unless user_signed_in?
      redirect_to lobby_path, alert: "Please log in to access this page."
    end
  end

  def current_user
    if session[:user_id].present?
      # You can also fetch the user from your database if you store user records
      {
        id: session[:user_id],
        email: session[:user_email],
        name: session[:user_name]
      }
    end
  end

  def user_signed_in?
    session[:user_id].present?
  end
end
