module Authorization
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, if: :requires_authentication?
    before_action :require_admin, if: :requires_admin?
  end

  def require_admin
    unless current_user&.admin?
      flash[:alert] = "You do not have permission to access this page"
      redirect_to root_path
    end
  end

  def requires_authentication?
    false
  end

  def requires_admin?
    false
  end
end