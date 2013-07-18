class AddHgValuesToSoilPExtractant < ActiveRecord::Migration
  def change
    remove_column :fields, :h_value
    remove_column :fields, :g_value

    add_column :soil_p_extractants, :h_value, :decimal
    add_column :soil_p_extractants, :g_value, :decimal
  end
end
