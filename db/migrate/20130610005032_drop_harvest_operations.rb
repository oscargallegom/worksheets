class DropHarvestOperations < ActiveRecord::Migration
  def change
    drop_table :harvest_operations
  end
end
