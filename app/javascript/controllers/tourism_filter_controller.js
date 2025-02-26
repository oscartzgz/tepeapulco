import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["categoryButton", "spotCard"]
  static values = {
    currentCategory: String
  }

  connect() {
    // Marcar el botón activo inicialmente
    this.updateActiveButton()
    
    // Extraer la categoría de la URL actual si existe
    this.extractCategoryFromUrl()
    
    // Escuchar eventos de navegación del historial (atrás/adelante)
    window.addEventListener('popstate', this.handlePopState.bind(this))
  }

  disconnect() {
    // Eliminar el event listener cuando el controlador se desconecta
    window.removeEventListener('popstate', this.handlePopState.bind(this))
  }

  // Extraer categoría de la URL actual
  extractCategoryFromUrl() {
    const urlPath = window.location.pathname
    const categoryMatch = urlPath.match(/\/turismo\/categoria\/(.+)/)
    
    if (categoryMatch && categoryMatch[1]) {
      this.currentCategoryValue = categoryMatch[1]
    } else if (urlPath === "/turismo") {
      this.currentCategoryValue = ""
    }
  }

  // Manejar eventos de navegación del historial
  handlePopState(event) {
    this.extractCategoryFromUrl()
    this.updateActiveButton()
    this.filterSpots()
  }

  // Al cambiar el valor de la categoría, actualizar la interfaz
  currentCategoryValueChanged() {
    this.updateActiveButton()
    this.filterSpots()
  }

  // Filtrar por categoría
  filter(event) {
    event.preventDefault()
    const categoryButton = event.currentTarget
    const category = categoryButton.dataset.category || ""
    
    // Actualizar la categoría actual
    this.currentCategoryValue = category
    
    // Actualizar la URL sin recargar la página y añadir entrada al historial
    if (category) {
      window.history.pushState({ category: category }, "", `/turismo/categoria/${category}`)
    } else {
      window.history.pushState({ category: "" }, "", "/turismo")
    }
  }

  // Actualizar qué botón tiene la clase activa
  updateActiveButton() {
    this.categoryButtonTargets.forEach(button => {
      const buttonCategory = button.dataset.category || ""
      
      if (buttonCategory === this.currentCategoryValue) {
        button.classList.remove("bg-gray-200", "text-gray-700", "hover:bg-gray-300")
        button.classList.add("bg-blue-600", "text-white")
      } else {
        button.classList.remove("bg-blue-600", "text-white")
        button.classList.add("bg-gray-200", "text-gray-700", "hover:bg-gray-300")
      }
    })
  }

  // Filtrar las tarjetas de lugares según la categoría seleccionada
  filterSpots() {
    const selectedCategory = this.currentCategoryValue
    this.spotCardTargets.forEach(card => {
      const cardCategory = card.dataset.category
      
      if (!selectedCategory || cardCategory === selectedCategory) {
        card.classList.remove("hidden")
      } else {
        card.classList.add("hidden")
      }
    })

    // Actualizar el título de la sección
    const sectionTitle = document.getElementById("places-section-title")
    if (sectionTitle) {
      if (selectedCategory) {
        const categoryTranslated = this.translateCategory(selectedCategory)
        sectionTitle.textContent = `Lugares ${categoryTranslated.toLowerCase()}s`
      } else {
        sectionTitle.textContent = "Todos los lugares turísticos"
      }
    }
  }

  // Método auxiliar para traducir categorías
  translateCategory(category) {
    const translations = {
      'cultural': 'Cultural',
      'natural': 'Natural',
      'historical': 'Histórico',
      'gastronomic': 'Gastronómico',
      'religious': 'Religioso',
      'recreational': 'Recreativo'
    }
    return translations[category] || category
  }
}