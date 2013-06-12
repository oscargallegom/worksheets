class DeleteCategoryFromManureTypes < ActiveRecord::Migration
  def change
    remove_column :manure_types, :category
  end
end
