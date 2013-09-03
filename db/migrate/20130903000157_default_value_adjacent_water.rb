class DefaultValueAdjacentWater < ActiveRecord::Migration
  def change
    change_column :fields, :is_field_adjacent_water, :boolean, :default => false
  end
end
