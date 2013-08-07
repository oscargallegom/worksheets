class DropPoultryTable < ActiveRecord::Migration
  def change
    drop_table :poultry
    drop_table :animal_lookups

    add_column :animals, :category, :integer
        add_column :animals, :typical_live_weight, :decimal
        add_column :animals, :animals_per_au, :decimal
        add_column :animals, :daily_manure_production_lbs_per_au, :decimal
        add_column :animals, :mortality_rate, :decimal
        add_column :animals, :fraction_p2o5, :decimal
        add_column :animals, :fraction_nh3, :decimal
        add_column :animals, :fraction_org_n, :decimal
        add_column :animals, :fraction_no3, :decimal
        add_column :animals, :fraction_org_p, :decimal
        add_column :animals, :fraction_po4p, :decimal
        add_column :animals, :volatilization_fraction, :decimal
        add_column :animals, :default_nh3_lbs, :decimal
        add_column :animals, :default_org_n_lbs, :decimal
        add_column :animals, :default_org_p_lbs, :decimal
        add_column :animals, :default_po4_lbs, :decimal
        add_column :animals, :storage_loss_fraction, :decimal
  end
end
