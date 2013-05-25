class CreateTillageOperationType < ActiveRecord::Migration
  def change
    create_table :tillage_operation_types do |t|
      t.string :name
    end
  end
end
