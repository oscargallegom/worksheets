class AddWeatherToFarms < ActiveRecord::Migration
  def change
    add_column :farms, :weather, :string
  end
end
