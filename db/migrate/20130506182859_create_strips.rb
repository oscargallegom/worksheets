class CreateStrips < ActiveRecord::Migration
  def change
    create_table :strips do |t|
      t.decimal :length
      t.integer :field_id

      t.timestamps
    end
  end
end
