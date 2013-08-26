class AddTmdlVaToFields < ActiveRecord::Migration
  def change
    add_column :fields, :tmdl_va, :string
  end
end
