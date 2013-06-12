class CreateManureFertilizerApplications < ActiveRecord::Migration
  def change
    create_table :manure_fertilizer_applications do |t|

      t.integer :crop_rotation_id

      t.integer :application_date_year
      t.integer :application_date_month
      t.integer :application_date_day

      t.integer :manure_type_id
      t.integer :manure_consistency_id

      t.integer :liquid_unit_type_id

      t.decimal :total_n_concentration
      t.decimal :p_concentration
      t.integer :p_type_id

      t.decimal :application_rate
      t.decimal :moisture_content

      t.boolean :is_precision_feeding
      t.boolean :is_phytase_treatment
      t.boolean :is_poultry_litter_treatment
      t.boolean :is_incorporated

      t.integer :incorporation_date_year
      t.integer :incorporation_date_month
      t.integer :incorporation_date_day

      t.decimal :incorporation_depth

      t.timestamps
    end
  end
end
