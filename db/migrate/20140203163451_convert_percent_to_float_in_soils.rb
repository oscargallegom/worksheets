class ConvertPercentToFloatInSoils < ActiveRecord::Migration
    def self.up
    change_table :soils do |t|
      t.change :bulk_density, :float
    end
  end
  def self.down
    change_table :soils do |t|
      t.change :bulk_density, :decimal
    end
  end
end
