class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # Debug: Registrar toda la información de autenticación
    auth_data = request.env["omniauth.auth"]
    Rails.logger.info "=== OAUTH DEBUG INFO ==="
    Rails.logger.info "Auth Provider: #{auth_data&.provider.inspect}"
    Rails.logger.info "Auth UID: #{auth_data&.uid.inspect}"
    Rails.logger.info "Auth Info Email: #{auth_data&.info&.email.inspect}"
    Rails.logger.info "Auth Info Name: #{auth_data&.info&.name.inspect}"
    Rails.logger.info "=== END OAUTH DEBUG ==="
    
    @user = User.from_omniauth(auth_data)
    
    # Debug: Verificar si el usuario tiene provider y uid
    Rails.logger.info "=== USER DEBUG INFO ==="
    Rails.logger.info "User Provider: #{@user.provider.inspect}"
    Rails.logger.info "User UID: #{@user.uid.inspect}"
    Rails.logger.info "User ID: #{@user.id.inspect}"
    Rails.logger.info "User Email: #{@user.email.inspect}"
    Rails.logger.info "=== END USER DEBUG ==="

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session["devise.google_oauth2_data"] = auth_data.except("extra")
      redirect_to new_user_registration_url
    end
  end

  def failure
    # Debug: Registrar la información del error
    Rails.logger.error "=== OAUTH FAILURE DEBUG INFO ==="
    Rails.logger.error "Error Reason: #{params[:message].inspect}" if params[:message]
    Rails.logger.error "Error Strategy: #{params[:strategy].inspect}" if params[:strategy]
    Rails.logger.error "=== END OAUTH FAILURE DEBUG ==="
    
    redirect_to root_path
  end
end
