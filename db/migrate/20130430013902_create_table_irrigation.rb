class CreateTableIrrigation < ActiveRecord::Migration
  create_table :irrigations do |t|
    t.string :name
    t.timestamps
  end
end
