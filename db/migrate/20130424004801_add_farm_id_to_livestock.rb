class AddFarmIdToLivestock < ActiveRecord::Migration
  def change
    rename_table :livestocks, :livestock
    add_column :livestock, :farm_id, :integer
  end
end
