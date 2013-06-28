class CreateEfficiencyBmps < ActiveRecord::Migration
  def change
    create_table :efficiency_bmps do |t|
      t.integer :bmp_type_id
      t.integer :field_type_id
      t.string :hgmr_code
      t.decimal :nitrogen_efficiency
      t.decimal :phosphorus_efficiency
      t.decimal :sediment_efficiency
    end
  end
end
