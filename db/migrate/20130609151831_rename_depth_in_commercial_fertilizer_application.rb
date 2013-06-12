class RenameDepthInCommercialFertilizerApplication < ActiveRecord::Migration
  def change
    rename_column :commercial_fertilizer_applications, :depth, :incorporation_depth
  end
end
