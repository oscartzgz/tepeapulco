class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :pages, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :description, length: { maximum: 500 }, allow_blank: true

  # Color para identificación visual (hexadecimal o nombre de color)
  validates :color, format: { with: /\A(#[0-9A-F]{6}|[a-z-]+)\z/i }, allow_blank: true

  # Icono (clase de FontAwesome u otro sistema de iconos)
  validates :icon, length: { maximum: 50 }, allow_blank: true

  scope :featured, -> { where(featured: true) }

  # Para generar el slug
  def normalize_friendly_id(string)
    string.to_s.parameterize
  end

  def should_generate_new_friendly_id?
    name_changed? || slug.blank?
  end
end
