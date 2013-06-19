class AddStreambankToFields < ActiveRecord::Migration
  def change
    add_column :fields, :is_streambank_restauration, :boolean
    add_column :fields, :streambank_restauration_length, :decimal
    add_column :fields, :is_streambank_restauration_planned, :boolean
  end
end
