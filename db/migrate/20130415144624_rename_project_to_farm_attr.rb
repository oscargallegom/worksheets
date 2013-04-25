class RenameProjectToFarmAttr < ActiveRecord::Migration
    def change
      rename_column :fields, :project_id, :farm_id
    end

end
