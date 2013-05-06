class CreateSoilTable < ActiveRecord::Migration
  def change
    create_table :soil_types do |t|
      t.string :name
    end
    create_table :soils do |t|
      t.integer :soil_type_id
      t.integer :field_id

      t.decimal :clay
      t.decimal :sand
      t.decimal :silt
      t.decimal :bulk_density
      t.decimal :organic_carbon
      t.decimal :slope

      t.timestamps
    end
  end
end
