class CreateFieldPoultry < ActiveRecord::Migration
  def change
    create_table :field_poultry do |t|

      t.integer :field_id

      t.integer :animal_id
      t.decimal :quantity
      t.integer :flocks_per_year
      t.decimal :days_in_growing_cycle
      t.decimal :n_excreted
      t.decimal :p205_excreted

      t.timestamps
    end
  end
end
