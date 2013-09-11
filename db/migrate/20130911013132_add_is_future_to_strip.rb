class AddIsFutureToStrip < ActiveRecord::Migration
  def change
    add_column :strips, :is_future, :boolean, :default => false
  end
end
