class AddPFractionToFields < ActiveRecord::Migration
  def change
    add_column :manure_fertilizer_applications, :p_fraction, :decimal
  end
end
