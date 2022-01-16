class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username password password_confirmation department])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[username password remember_me])
  end

  private

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || users_path
  end

  def after_sign_out_path_for(_)
    new_user_session_path
  end
end
