class AddHelSoilsToFields < ActiveRecord::Migration
  def change
    add_column :fields, :hel_soils, :boolean
  end
end
