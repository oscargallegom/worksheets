class CreateLiquidUnitTypes < ActiveRecord::Migration
  def change
    create_table :liquid_unit_types do |t|
      t.string :name
    end
  end
end
