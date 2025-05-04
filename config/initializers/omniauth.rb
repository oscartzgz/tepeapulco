# config/initializers/omniauth.rb
OmniAuth.config.allowed_request_methods = [ :post, :get ]
OmniAuth.config.silence_get_warning = true
OmniAuth.config.logger = Rails.logger

OmniAuth.config.on_failure = Proc.new { |env|
  Rails.logger.error "OmniAuth ERROR: #{env['omniauth.error']&.inspect}"
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
