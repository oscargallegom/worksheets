class AddHuc12NameToFields < ActiveRecord::Migration
  def change
    add_column :fields, :watershed_name, :string
  end
end
