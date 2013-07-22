class AddFertilizerSetbackToFields < ActiveRecord::Migration
  def change
    add_column :fields, :is_fertilizer_application_setback, :boolean
    add_column :fields, :fertilizer_application_setback_average_width, :decimal
    add_column :fields, :fertilizer_application_setback_length, :decimal
    add_column :fields, :is_fertilizer_application_setback_planned, :boolean
  end
end
