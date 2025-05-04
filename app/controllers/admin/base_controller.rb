class Admin::BaseController < ApplicationController
  def requires_authentication?
    true
  end

  def requires_admin?
    true
  end
end