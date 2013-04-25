class AddCoordinatesToProject < ActiveRecord::Migration
  def change
    add_column :projects, :coordinates, :text
  end
end
