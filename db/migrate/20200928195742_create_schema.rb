class CreateSchema < ActiveRecord::Migration[6.0]
  def change
    create_table :cocktails do |t|
      t.string :name
      t.text :instructions
      t.string :category
      t.string :glass
    end
    create_table :ingredients do |t|
      t.string :name
      t.text :description
    end
    create_table :cocktail_ingredients do |t|
      t.integer :cocktail_id
      t.integer :ingredient_id
      t.string :measure
    end
  end
end
