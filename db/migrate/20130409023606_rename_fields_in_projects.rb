class RenameFieldsInProjects < ActiveRecord::Migration
  def change
    rename_column :projects, :state_id, :site_state_id
    rename_column :projects, :county_id, :site_county_id
  end
end
