class AddFenceLengthFutureToFields < ActiveRecord::Migration
  def change
    add_column :fields, :fence_length_future, :decimal
  end
end
