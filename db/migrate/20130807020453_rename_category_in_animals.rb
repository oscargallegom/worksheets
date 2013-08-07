class RenameCategoryInAnimals < ActiveRecord::Migration
  def change
    rename_column :animals, :category, :category_id
  end
end
