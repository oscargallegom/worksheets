class AddFarmIdToFields < ActiveRecord::Migration
  def change
    add_column :fields, :farm_id, :integer
  end
end
