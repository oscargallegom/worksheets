class CreateSegments < ActiveRecord::Migration
  def change
    create_table :watershed_segments do |t|

      t.string :key
      t.text :description
      t.string :hgmr_code
      t.string :state_name
      t.string :county_name
      t.integer :fips
      t.text :major_basin
      t.text :trib_strat_basin

      t.timestamps
    end
  end
end
