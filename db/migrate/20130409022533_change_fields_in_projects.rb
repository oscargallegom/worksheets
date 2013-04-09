class ChangeFieldsInProjects < ActiveRecord::Migration
  def change
    rename_column :projects, :site_address_1, :site_street_1
    rename_column :projects, :site_address_2, :site_street_2
    add_column :projects, :site_description, :text
  end

end
