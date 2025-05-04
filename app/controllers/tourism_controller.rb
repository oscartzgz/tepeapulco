class TourismController < ApplicationController
  def index
    tourism_category = Category.find_by(slug: "turismo")
    @pages = Page.where(category: tourism_category)
  end
end
