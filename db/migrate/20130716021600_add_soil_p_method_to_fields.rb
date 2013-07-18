class AddSoilPMethodToFields < ActiveRecord::Migration
  def change
    add_column :fields, :soil_test_p_extractant_id, :integer
    remove_column :fields, :p_test_method_id
  end
end
