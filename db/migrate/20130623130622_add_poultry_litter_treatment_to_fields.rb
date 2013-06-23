class AddPoultryLitterTreatmentToFields < ActiveRecord::Migration
  def change
    add_column :fields, :is_poultry_litter_treatment, :boolean
  end
end
