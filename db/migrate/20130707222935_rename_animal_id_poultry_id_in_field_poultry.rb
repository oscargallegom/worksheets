class RenameAnimalIdPoultryIdInFieldPoultry < ActiveRecord::Migration
  def change
    rename_column :field_poultry, :animal_id, :poultry_id
  end
end
