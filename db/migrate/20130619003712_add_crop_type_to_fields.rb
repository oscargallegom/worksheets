class AddCropTypeToFields < ActiveRecord::Migration
  def change
    add_column :fields, :crop_type_id, :integer
  end
end
