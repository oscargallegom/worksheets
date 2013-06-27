class CreateEfficiencyBmps < ActiveRecord::Migration
  def change
    create_table :efficiency_bmps do |t|
      t.string :bmp_abbreviation
      t.string :field_type
      t.string :watershed_segment
      t.decimal :nitrogen_efficiency
      t.decimal :phosphorus_efficiency
      t.decimal :sediment_efficiency
    end
  end
end
