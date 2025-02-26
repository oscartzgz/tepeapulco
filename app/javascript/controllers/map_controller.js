import { Controller } from "@hotwired/stimulus"
import L from 'leaflet'

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    spots: Array
  }
  
  connect() {
    // Configurar iconos para los marcadores
    L.Icon.Default.mergeOptions({
      iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
      iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
      shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
    });
    
    // Inicializar mapa centrado en Tepeapulco
    this.map = L.map(this.element).setView([19.7883, -98.5550], 13)
    
    // Añadir capa de OpenStreetMap
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(this.map)
    
    // Añadir marcadores para cada lugar turístico
    this.spotsValue.forEach(spot => {
      const marker = L.marker([spot.latitude, spot.longitude]).addTo(this.map)
      
      // Popup con información básica
      marker.bindPopup(`
        <div class="text-center">
          <h3 class="font-bold">${spot.name}</h3>
          <p class="text-sm">${spot.category}</p>
          <a href="/tourist_spots/${spot.id}" class="text-blue-600 hover:underline text-sm">Ver detalles</a>
        </div>
      `)
    })
  }
}