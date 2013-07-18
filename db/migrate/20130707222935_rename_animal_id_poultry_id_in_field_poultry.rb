class RenameAnimalIdPoultryIdInFieldPoultry < ActiveRecord::Migration
  def change
    rename_column :fields, :animal_id, :poultry_id
  end
end
