class AddCoordinatesToFields < ActiveRecord::Migration
  def change
    add_column :fields, :coordinates, :text
  end
end
