class CreateCompanies < ActiveRecord::Migration[8.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :website_url
      t.string :careers_url
      t.string :country, null: false
      t.string :city
      t.text :description
      t.boolean :featured, default: false
      t.boolean :published, default: false

      t.timestamps
    end
    add_index :companies, :slug, unique: true
  end
end
