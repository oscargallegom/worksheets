class AddFieldsToProjectsTable < ActiveRecord::Migration
  def change
    add_column :projects, :state_id, :integer, :null => false
    add_column :projects, :county_id, :integer, :null => false

    change_column :projects, :site_name, :string, :null => false
  end
end
