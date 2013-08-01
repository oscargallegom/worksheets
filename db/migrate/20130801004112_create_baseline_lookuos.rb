class CreateBaselineLookuos < ActiveRecord::Migration
  def change
    create_table :baseline_lookups do |t|
      t.integer :state_id
      t.string :major_basin
      t.integer :field_type_id
      t.decimal :total_n_baseline
      t.decimal :total_p_baseline
      t.decimal :total_sediment_baseline
      t.decimal :n_adjustment_factor
      t.decimal :p_adjustment_factor
      t.decimal :sediment_adjustment_factor
    end
  end
end
