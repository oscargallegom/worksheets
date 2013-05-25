class CreateTillageOperations < ActiveRecord::Migration
  def change
    create_table :tillage_operations do |t|

      t.integer :crop_rotation_id

      t.integer :start_date_year
      t.integer :start_date_month
      t.integer :start_date_day

      t.integer :tillage_operation_type_id

      t.timestamps
    end
  end
end
