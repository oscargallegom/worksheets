class CreateSoilTextures < ActiveRecord::Migration
  def change
    add_column :fields, :soil_texture_id, :integer

    create_table :soil_textures do |t|
      t.string :name
      t.decimal :percent_sand
      t.decimal :percent_silt
      t.decimal :percent_clay
      t.decimal :bulk_density
    end
  end
end
