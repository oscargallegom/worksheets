class CreateTableFieldTypes < ActiveRecord::Migration
  create_table :field_types do |t|
    t.string :name
    t.timestamps
  end
end
