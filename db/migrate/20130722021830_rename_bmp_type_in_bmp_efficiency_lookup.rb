class RenameBmpTypeInBmpEfficiencyLookup < ActiveRecord::Migration
  def change
    rename_column :bmp_efficiency_lookups, :bm_type_id, :bmp_type_id
  end
end
