class CreateEndOfSeasonTypes < ActiveRecord::Migration
  def change
    create_table :end_of_season_types do |t|
      t.string :name
    end
  end
end
