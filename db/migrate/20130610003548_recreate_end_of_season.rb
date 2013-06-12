class RecreateEndOfSeason < ActiveRecord::Migration
  def change
    create_table :end_of_seasons do |t|

      t.integer :end_of_season_type_id

      t.integer :year
      t.integer :month
      t.integer :day

      t.integer :crop_rotation_id

      t.timestamps
    end
  end
end
