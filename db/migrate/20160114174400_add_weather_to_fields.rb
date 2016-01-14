class AddWeatherToFields < ActiveRecord::Migration
  def change
    add_column :fields, :weather, :string
  end
end
