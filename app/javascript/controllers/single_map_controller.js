import { Controller } from "@hotwired/stimulus"
import L from 'leaflet'

// app/javascript/controllers/single_map_controller.js
export default class extends Controller {
  static values = {
    latitude: Number,
    longitude: Number,
    name: String
  }
  
  connect() {
    // Configurar iconos para los marcadores
    L.Icon.Default.mergeOptions({
      iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
      iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
      shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
    });
    
    // Cargar el mapa solo si tenemos coordenadas válidas
    if (this.hasLatitudeValue && this.hasLongitudeValue) {
      this.initMap()
    }
  }
  
  disconnect() {
    // Limpiar el mapa al desconectar para evitar fugas de memoria
    if (this.map) {
      this.map.remove()
    }
  }
  
  initMap() {
    // Inicializar el mapa centrado en la ubicación del lugar turístico
    this.map = L.map(this.element).setView([this.latitudeValue, this.longitudeValue], 15)
    
    // Añadir capa de OpenStreetMap
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(this.map)
    
    // Añadir marcador para el lugar turístico
    const marker = L.marker([this.latitudeValue, this.longitudeValue]).addTo(this.map)
    
    // Popup con el nombre del lugar
    if (this.hasNameValue) {
      marker.bindPopup(`<div class="text-center font-bold">${this.nameValue}</div>`).openPopup()
    }
  }
}