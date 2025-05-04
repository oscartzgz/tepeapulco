class Page < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  # Status for publishing control
  enum :status, { draft: 0, published: 1 }, default: :draft

  # Page metadata for SEO
  validates :meta_title, length: { maximum: 60 }, allow_blank: true
  validates :meta_description, length: { maximum: 160 }, allow_blank: true

  # Scopes
  scope :published, -> { where(status: :published) }
  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :featured, -> { where(show_in_menu: true).order(menu_order: :asc) }

  # Custom slugs
  def normalize_friendly_id(string)
    string.to_s.parameterize
  end

  def should_generate_new_friendly_id?
    title_changed? || slug.blank?
  end
end
