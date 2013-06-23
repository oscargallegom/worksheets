class AddLivestockInputMethodsToFields < ActiveRecord::Migration
  def change
    add_column :fields, :livestock_input_method_id, :integer
  end
end
