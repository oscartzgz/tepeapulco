class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  def self.from_omniauth(auth)
    # Debug: Registrar la información que se usa para buscar o crear usuario
    Rails.logger.info "=== FROM_OMNIAUTH DEBUG ==="
    Rails.logger.info "Auth Provider: #{auth&.provider.inspect}"
    Rails.logger.info "Auth UID: #{auth&.uid.inspect}"
    
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize
    
    # Debug: Verificar si el usuario ya existía o es nuevo
    is_new_user = user.new_record?
    Rails.logger.info "Is New User: #{is_new_user}"
    
    # Asegurar que provider y uid se asignen explícitamente
    user.provider = auth.provider
    user.uid = auth.uid
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20] if user.new_record?
    user.name = auth.info.name
    user.skip_confirmation!
    user.confirmed_at = Time.current if user.confirmed_at.nil?
    
    # Debug: Guardar el usuario y registrar si hubo errores
    saved = user.save
    Rails.logger.info "User saved: #{saved}"
    Rails.logger.info "User errors: #{user.errors.full_messages}" if !saved
    Rails.logger.info "Final Provider: #{user.provider.inspect}"
    Rails.logger.info "Final UID: #{user.uid.inspect}"
    Rails.logger.info "=== END FROM_OMNIAUTH DEBUG ==="
    
    user
  end

  def admin?
    admin
  end

  # Override Devise method to allow users with OAuth providers to update their profiles
  def update_without_password(params)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update(params)
    clean_up_passwords
    result
  end
end
