class AddIsFieldAdjacentToWaterToFields < ActiveRecord::Migration
  def change
    add_column :fields, :is_field_adjacent_water, :boolean
  end
end
