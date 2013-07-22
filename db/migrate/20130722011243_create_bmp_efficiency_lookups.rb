class CreateBmpEfficiencyLookups < ActiveRecord::Migration
  def change
    create_table :bmp_efficiency_lookups do |t|
      t.integer :bm_type_id
      t.integer :field_type_id
      t.string :hgmr_code
      t.decimal :n_reduction
      t.decimal :p_reduction
      t.decimal :sediment_reduction
    end
  end
end
