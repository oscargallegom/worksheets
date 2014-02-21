class AddPoultryIdToFieldPoultry < ActiveRecord::Migration
  def change
    add_column :field_poultry, :poultry_id, :integer
  end
end
