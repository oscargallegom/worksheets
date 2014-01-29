class AddIdToAnimalsFarms < ActiveRecord::Migration
  def change
  	create_table :animals_farms do |t|
  		t.decimal :animals_units
  		t.belongs_to :farm
  		t.belongs_to :animal
    end

  end
end
