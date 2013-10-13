class AddFieldsToSoilTexture < ActiveRecord::Migration
  def change
    add_column :soil_textures, :organic_carbon, :decimal
    add_column :soil_textures, :slope, :decimal
  end
end
