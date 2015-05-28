class ApplicationController < ActionController::Base


  before_action :authorize

  helper_method :current_user, :is_user_logged_in?, :plivo

  protect_from_forgery with: :exception

  def current_user
    @current_user = User.find(session[:user_id]) unless session[:user_id].nil?
  end

  def plivo
    @plivo = Plivo::RestAPI.new('MAZJAZZJRLYTAYYZGWYZ', 'YmFlNTdhNWY2OWMzYWJmMWY2OWYwOGE5NDMxZTYy')
  end

  def is_user_logged_in?
    session[:user_id]
  end


  protected

  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to login_url, notice: "Please log in"
    end
  end
end
