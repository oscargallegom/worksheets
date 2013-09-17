class AddIdToAnimalsFarms < ActiveRecord::Migration
  def change
    add_column :animals_farms, :id, :primary_key
  end
end
