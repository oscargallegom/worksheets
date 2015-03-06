class AddTotalsToFields < ActiveRecord::Migration
  def change
    add_column :fields, :totals, :text
  end
end
