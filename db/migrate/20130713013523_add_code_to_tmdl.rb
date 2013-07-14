class AddCodeToTmdl < ActiveRecord::Migration
  def change
    add_column :tmdls, :code, :bigint
  end
end
