class AddProjectIdToField < ActiveRecord::Migration
  def change
    add_column :projects, :state_id, :integer
    add_column :projects, :county_id, :integer
  end
end
