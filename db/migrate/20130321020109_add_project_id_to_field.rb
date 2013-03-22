class AddProjectIdToField < ActiveRecord::Migration
  def change
    add_column  :fields, :project_id, :integer
  end
end
