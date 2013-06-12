class AddManureTypeCategoryIdToManureTypes < ActiveRecord::Migration
  def change
    add_column :manure_types, :manure_type_category_id, :integer
  end
end
