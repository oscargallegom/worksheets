class DeletePtestMethod < ActiveRecord::Migration
  def change
    drop_table :p_test_methods
    rename_column :soil_p_extractants, :p_value,:b_value
  end
end
