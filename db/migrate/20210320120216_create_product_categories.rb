class CreateProductCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :product_categories do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    add_index :product_categories, :name, unique: true
    add_index :product_categories, :code, unique: true
  end
end
