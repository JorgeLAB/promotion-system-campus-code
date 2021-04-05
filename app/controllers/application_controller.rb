class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  add_flash_types :success

  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
