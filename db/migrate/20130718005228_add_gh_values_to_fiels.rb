class AddGhValuesToFiels < ActiveRecord::Migration
  def change
    add_column :fields, :h_value, :decimal
    add_column :fields, :g_value, :decimal
  end
end
