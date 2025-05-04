class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :color
      t.string :icon
      t.integer :position
      t.boolean :featured, default: false

      t.timestamps
    end
    
    add_index :categories, :slug, unique: true
    add_index :categories, :featured
  end
end