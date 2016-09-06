class AddFieldsToGrazingLivestocks < ActiveRecord::Migration
  def change
    add_column :grazing_livestocks, :consecutive_hours, :float
    add_column :grazing_livestocks, :rest_time, :integer
    add_column :grazing_livestocks, :paddocks, :integer
    add_column :grazing_livestocks, :supplemental_feed, :boolean
    add_column :grazing_livestocks, :round_bales, :integer
  end
end
