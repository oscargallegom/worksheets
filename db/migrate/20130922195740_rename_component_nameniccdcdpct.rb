class RenameComponentNameniccdcdpct < ActiveRecord::Migration
  def change
    remove_column :soils, :component_name
    add_column :soils, :niccdcdpct, :decimal
  end
end
