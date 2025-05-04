class Admin::PagesController < Admin::BaseController
  before_action :set_page, only: [ :show, :edit, :update, :destroy, :toggle_status, :editor ]

  def index
    @categories = Category.order(position: :asc, name: :asc)
    @category = params[:category_id].present? ? Category.friendly.find(params[:category_id]) : nil
    
    @pages = Page.all
    @pages = @pages.by_category(@category.id) if @category
    @pages = @pages.order(created_at: :desc)
  end

  def show
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    @page.user = current_user

    if @page.save
      redirect_to admin_pages_path, notice: "Página creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def editor
    # Asegurar que el contenido esté en formato JSON
    if @page.content.blank?
      @page.content = "{}"
    elsif !valid_json?(@page.content)
      @page.content = "{}"
    end

    render layout: "editor"
  end

  # Helper para validar JSON
  def valid_json?(json)
    begin
      JSON.parse(json)
      true
    rescue JSON::ParserError
      false
    end
  end

  def update
    if @page.update(page_params)
      respond_to do |format|
        format.html { redirect_to admin_pages_path, notice: "Página actualizada exitosamente." }
        format.json { render json: { success: true, message: "Página actualizada exitosamente" } }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @page.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @page.destroy
    redirect_to admin_pages_path, notice: "Página eliminada exitosamente."
  end

  def toggle_status
    if @page.draft?
      @page.published!
      notice = "Página publicada exitosamente."
    else
      @page.draft!
      notice = "Página movida a borradores."
    end

    redirect_to admin_pages_path, notice: notice
  end

  private

  def set_page
    @page = Page.friendly.find(params[:id])
  end

  def page_params
    # Si recibimos content y styles pero no html, calculamos el html
    if params[:page][:content].present? && !params[:page][:html].present?
      # Procesamos el HTML directamente para guardarlo
      params[:page][:html] = generate_html_from_content(params[:page][:content], params[:page][:styles])
    end
    
    params.require(:page).permit(
      :title, :slug, :content, :styles, :assets, :status,
      :meta_title, :meta_description, :featured_image,
      :show_in_menu, :menu_order, :category_id, :html
    )
  end
  
  # Método para generar HTML a partir del contenido de GrapeJS
  def generate_html_from_content(content_json, styles)
    return '' unless content_json.present?
    
    begin
      content = JSON.parse(content_json)
      
      # Si ya tiene HTML, usarlo directamente
      return content['html'] if content.is_a?(Hash) && content['html'].present?
      
      # Si no tiene HTML pero tiene componentes, generamos un mensaje para regenerarlo
      "<div class='bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700 p-4' role='alert'>
        <p class='font-bold'>HTML no regenerado</p>
        <p>El HTML se regenerará la próxima vez que edites esta página con el editor.</p>
      </div>"
    rescue JSON::ParserError => e
      # Si hay un error en el JSON, devolver un mensaje de error
      "<div class='bg-red-100 border-l-4 border-red-500 text-red-700 p-4' role='alert'>
        <p class='font-bold'>Error en el contenido</p>
        <p>Hubo un error al procesar el contenido de la página. Por favor edita la página de nuevo.</p>
      </div>"
    end
  end
end
