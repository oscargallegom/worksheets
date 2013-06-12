class UpdateEndOfSeason < ActiveRecord::Migration
  def change
    drop_table :end_of_seasons
    add_column :harvest_operations, :end_of_season_type_id, :integer

  end
end
