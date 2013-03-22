class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :name
      t.decimal :area
      t.string :baseline_load

      t.timestamps
    end
  end
end
