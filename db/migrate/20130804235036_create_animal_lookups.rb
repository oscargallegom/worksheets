class CreateAnimalLookups < ActiveRecord::Migration
  def change
    create_table :animal_lookups do |t|
      t.integer :animal_id
      t.decimal :typical_live_weight
      t.decimal :animals_per_au
      t.decimal :daily_manure_production_lbs_per_au
      t.decimal :mortality_rate
      t.decimal :fraction_p2o5
      t.decimal :fraction_nh3
      t.decimal :fraction_org_n
      t.decimal :fraction_no3
      t.decimal :fraction_org_p
      t.decimal :fraction_po4p
    end
  end
end
