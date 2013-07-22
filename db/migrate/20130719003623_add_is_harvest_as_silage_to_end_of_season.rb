class AddIsHarvestAsSilageToEndOfSeason < ActiveRecord::Migration
  def change
    add_column :end_of_seasons, :is_harvest_as_silage, :boolean
  end
end
