class DropBaselineLookupTable < ActiveRecord::Migration
  def change
    drop_table :baseline_lookups
  end
end
