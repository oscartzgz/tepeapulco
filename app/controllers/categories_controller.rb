class CategoriesController < ApplicationController
  def show
    @category = Category.friendly.find(params[:id])
    @pages = @category.pages.published.order(created_at: :desc)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "La categoría solicitada no existe o no está disponible."
  end
end