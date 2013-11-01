class AddPTypeIdToCommercialFertilizerApplications < ActiveRecord::Migration
  def change
    add_column :commercial_fertilizer_applications, :p_type_id, :integer
  end
end
