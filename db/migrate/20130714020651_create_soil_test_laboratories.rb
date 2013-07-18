class CreateSoilTestLaboratories < ActiveRecord::Migration
  def change
    create_table :soil_test_laboratories do |t|
      t.string :name
      t.integer :state_id
    end
  end
end
