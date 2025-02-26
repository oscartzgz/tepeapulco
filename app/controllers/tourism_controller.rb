class TourismController < ApplicationController
   # Acción para el índice de turismo
   def index
    @featured_spots = tourism_spots.select { |_, spot| spot["featured"] }
    @spots_by_category = tourism_spots.group_by { |_, spot| spot["category"] }
    @selected_category = params[:category]

    if @selected_category
      @filtered_spots = tourism_spots.select { |_, spot| spot["category"] == @selected_category }
    else
      @filtered_spots = tourism_spots
    end
  end

  # Acción para mostrar un lugar turístico específico
  def show
    @spot_id = params[:id]
    @spot = tourism_spots[@spot_id]

    if @spot.nil?
      redirect_to tourism_index_path, alert: "El lugar turístico no fue encontrado."
      return
    end

    # Si tiene landing page personalizada, busca la vista directamente en tourism/
    if @spot["has_landing_page"]
      render "tourism/#{@spot_id}"
    else
      # Vista genérica para lugares sin landing page
      render :show
    end
  end

  private

  # Método para cargar los lugares turísticos desde el YAML
  def tourism_spots
    @tourism_spots ||= begin
      yaml_file = Rails.root.join("config", "tourism_spots.yml")
      YAML.load_file(yaml_file)
    end
  end

  # Helper para obtener todos los lugares
  helper_method :tourism_spots

  # Helper para obtener las categorías únicas
  def categories
    @categories ||= tourism_spots.values.map { |spot| spot["category"] }.uniq
  end
  helper_method :categories

  # Helper para traducir categorías
  def translate_category(category)
    {
      "cultural" => "Cultural",
      "natural" => "Natural",
      "historical" => "Hist\u00F3rico",
      "gastronomic" => "Gastron\u00F3mico",
      "religious" => "Religioso",
      "recreational" => "Recreativo"
    }[category] || category.titleize
  end
  helper_method :translate_category

  # Helper para obtener el color correspondiente a una categoría
  def category_color(category)
    {
      "cultural" => "bg-purple-500",
      "natural" => "bg-green-500",
      "historical" => "bg-amber-500",
      "gastronomic" => "bg-red-500",
      "religious" => "bg-blue-500",
      "recreational" => "bg-teal-500"
    }[category] || "bg-gray-500"
  end
  helper_method :category_color
end
