class Users::RegistrationsController < Devise::RegistrationsController
  # Allow users to edit their profile without providing current password if they signed up with OAuth
  def update_resource(resource, params)
    if resource.provider.present?
      # User signed up with OAuth, so we allow them to update without a password
      resource.update_without_password(params)
    else
      super
    end
  end
end