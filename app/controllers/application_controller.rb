class ApplicationController < ActionController::Base
  before_action :authorize!
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :success, :info, :warning, :danger

  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorize!
    unless authorized?
      redirect_to root_url, danger: "back off"

    end
  end

  def authorized?
    current_permission.allow?(params[:controller], params[:action])
  end

  def current_permission
    @current_permission||=PermissionService.new(current_user)
  end

end
