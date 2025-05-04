class PagesController < ApplicationController
  def show
    @page = Page.friendly.published.find(params[:id])
    
    # Si la página no tiene HTML guardado pero tiene contenido,
    # podría ser una página antigua que necesita ser actualizada
    if !@page.html.present? && @page.content.present?
      Rails.logger.info "Página sin HTML renderizado: #{@page.id} - #{@page.title}"
    end
    
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "La página solicitada no existe o no está disponible."
  end
end