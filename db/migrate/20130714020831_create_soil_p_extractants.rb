class CreateSoilPExtractants < ActiveRecord::Migration
  def change
    create_table :soil_p_extractants do |t|
      t.string :name
      t.string :unit
      t.decimal :m_value
      t.decimal :p_value
      t.integer :formula_code

      t.integer :soil_test_laboratory_id
    end
  end
end
