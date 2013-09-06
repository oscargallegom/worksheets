class AddOtherLandConversionToFields < ActiveRecord::Migration
  def change
    add_column :fields, :other_land_use_conversion_acres, :decimal
    add_column :fields, :other_land_use_conversion_vegetation_type_id, :integer
    add_column :fields, :is_other_land_use_conversion_planned, :boolean
  end
end
