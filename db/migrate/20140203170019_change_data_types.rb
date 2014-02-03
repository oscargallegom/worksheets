class ConvertPercentToFloatInSoils < ActiveRecord::Migration
    def self.up
    change_table :animals do |t|
      t.change :typical_live_weight, :float
      t.change :animals_per_au, :float
      t.change :daily_manure_production_lbs_per_au, :float
      t.change :mortality_rate, :float
      t.change :fraction_p2o5, :float
      t.change :fraction_nh3, :float
      t.change :fraction_org_n, :float
      t.change :fraction_no3, :float
      t.change :fraction_org_p, :float
      t.change :fraction_po4p, :float
      t.change :volatilization_fraction, :float
      t.change :default_nh3_lbs, :float
      t.change :default_org_n_lbs, :float
      t.change :default_org_p_lbs, :float
      t.change :default_po4_lbs, :float
      t.change :storage_loss_fraction, :float
    end
  end
  def self.down
    change_table :animals do |t|
      t.change :typical_live_weight, :decimal
      t.change :animals_per_au, :decimal
      t.change :daily_manure_production_lbs_per_au, :decimal
      t.change :mortality_rate, :decimal
      t.change :fraction_p2o5, :decimal
      t.change :fraction_nh3, :decimal
      t.change :fraction_org_n, :decimal
      t.change :fraction_no3, :decimal
      t.change :fraction_org_p, :decimal
      t.change :fraction_po4p, :decimal
      t.change :volatilization_fraction, :decimal
      t.change :default_nh3_lbs, :decimal
      t.change :default_org_n_lbs, :decimal
      t.change :default_org_p_lbs, :decimal
      t.change :default_po4_lbs, :decimal
      t.change :storage_loss_fraction, :decimal
    end
  end
end
