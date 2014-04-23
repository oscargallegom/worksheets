class AddFutureSolublePToFields < ActiveRecord::Migration
  def change
    add_column :fields, :future_soluble_p, :float
  end
end
