class AddFieldsToSoils < ActiveRecord::Migration
  def change
    add_column :soils, :percent, :decimal
    add_column :soils, :mukey, :integer
    add_column :soils, :compname, :string
    add_column :soils, :muname, :string
  end
end
