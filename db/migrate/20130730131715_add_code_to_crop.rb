class AddCodeToCrop < ActiveRecord::Migration
  def change
    add_column :crops, :code, :integer
  end
end
