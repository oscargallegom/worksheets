class AddFutureFieldTypeIdToFields < ActiveRecord::Migration
  def change
    add_column :fields, :future_field_type_id, :integer, :default => 0
  end
end
