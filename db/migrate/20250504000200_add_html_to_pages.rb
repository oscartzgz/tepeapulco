class AddHtmlToPages < ActiveRecord::Migration[8.0]
  def change
    add_column :pages, :html, :text
  end
end