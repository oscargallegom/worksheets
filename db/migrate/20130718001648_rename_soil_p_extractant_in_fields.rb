class RenameSoilPExtractantInFields < ActiveRecord::Migration
  def change
    rename_column :fields, :soil_test_p_extractant_id, :soil_p_extractant_id
  end
end
