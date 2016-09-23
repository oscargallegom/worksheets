class AddNameToFutureFieldTypes < ActiveRecord::Migration
  def change
    add_column :future_field_types, :name, :string
  end
end
