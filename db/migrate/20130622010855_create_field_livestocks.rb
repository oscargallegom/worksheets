class CreateFieldLivestocks < ActiveRecord::Migration
  def change
    create_table :field_livestocks do |t|
      t.integer :field_id

      t.integer :animal_id
      t.decimal :quantity
      t.integer :days_per_year_confined
      t.decimal :hours_per_day_confined
      t.decimal :n_excreted
      t.decimal :p205_excreted
      t.decimal :total_manure

    end
  end
end
