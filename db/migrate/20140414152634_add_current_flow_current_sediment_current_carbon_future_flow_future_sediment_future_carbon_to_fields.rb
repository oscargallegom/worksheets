class AddCurrentFlowCurrentSedimentCurrentCarbonFutureFlowFutureSedimentFutureCarbonToFields < ActiveRecord::Migration
  def change
    add_column :fields, :current_flow, :float
    add_column :fields, :current_sediment, :float
    add_column :fields, :current_carbon, :float
    add_column :fields, :future_flow, :float
    add_column :fields, :future_sediment, :float
    add_column :fields, :future_carbon, :float
  end
end
