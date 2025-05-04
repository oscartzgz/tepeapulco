class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  
  def index
    @categories = Category.all.order(position: :asc, name: :asc)
  end
  
  def show
    @pages = @category.pages.order(created_at: :desc)
  end
  
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new(category_params)
    
    if @category.save
      redirect_to admin_categories_path, notice: "Categoría creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Categoría actualizada exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    if @category.pages.exists?
      redirect_to admin_categories_path, alert: "No se puede eliminar la categoría porque tiene páginas asociadas."
    else
      @category.destroy
      redirect_to admin_categories_path, notice: "Categoría eliminada exitosamente."
    end
  end
  
  private
  
  def set_category
    @category = Category.friendly.find(params[:id])
  end
  
  def category_params
    params.require(:category).permit(
      :name, :slug, :description, :color, :icon, :position, :featured
    )
  end
end