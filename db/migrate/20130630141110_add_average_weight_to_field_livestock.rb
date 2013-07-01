class AddAverageWeightToFieldLivestock < ActiveRecord::Migration
  def change
    add_column :field_livestocks, :average_weight, :decimal
  end
end
