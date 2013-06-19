class RenameRestaurationInFields < ActiveRecord::Migration
  def change
    rename_column :fields, :is_streambank_restauration, :is_streambank_restoration
    rename_column :fields, :streambank_restauration_length, :streambank_restoration_length
    rename_column :fields, :is_streambank_restauration_planned, :is_streambank_restoration_planned
  end
end
