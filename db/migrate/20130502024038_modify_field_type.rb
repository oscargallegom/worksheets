class ModifyFieldType < ActiveRecord::Migration
  def change
    change_column :farms, :acres, :decimal
    change_column :fields, :acres, :decimal
  end
end
