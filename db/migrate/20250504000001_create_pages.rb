class CreatePages < ActiveRecord::Migration[8.0]
  def change
    create_table :pages do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :content, null: false, default: "{}"
      t.text :styles
      t.text :assets
      t.integer :status, default: 0
      t.string :meta_title
      t.text :meta_description
      t.string :featured_image
      t.boolean :show_in_menu, default: false
      t.integer :menu_order
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :pages, :slug, unique: true
    add_index :pages, :status
    add_index :pages, :show_in_menu
  end
end