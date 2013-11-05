class RemoveDaysGrazedFromGrazingLivestock < ActiveRecord::Migration
  def change
    remove_column :grazing_livestocks, :days_grazed
  end
end
