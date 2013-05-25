class CreateHarvestOperations < ActiveRecord::Migration
  def change
    create_table :harvest_operations do |t|

      t.integer :start_date_year
      t.integer :start_date_month
      t.integer :start_date_day

      t.timestamps
    end
  end
end
