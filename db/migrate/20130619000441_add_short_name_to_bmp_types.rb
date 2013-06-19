class AddShortNameToBmpTypes < ActiveRecord::Migration
  def change
    add_column :bmp_types, :abbreviation, :text
  end
end
