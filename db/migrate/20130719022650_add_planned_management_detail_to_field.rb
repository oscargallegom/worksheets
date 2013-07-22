class AddPlannedManagementDetailToField < ActiveRecord::Migration
  def change
    add_column :fields, :planned_management_details, :text
  end
end
