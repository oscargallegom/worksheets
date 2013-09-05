class AddExclusionDescriptionToFields < ActiveRecord::Migration
  def change
    add_column :fields, :exclusion_description, :text
  end
end
