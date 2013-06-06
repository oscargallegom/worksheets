class AddEfficiencyToFields < ActiveRecord::Migration
  def change
    add_column :fields, :efficiency, :decimal
  end
end
