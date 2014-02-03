class ChangeTotalManureInFieldLivestocks < ActiveRecord::Migration
    def self.up
    change_table :field_livestocks do |t|
      t.change :total_manure, :float
    end
  end
  def self.down
    change_table :field_livestocks do |t|
      t.change :total_manure, :decimal
    end
  end
end
