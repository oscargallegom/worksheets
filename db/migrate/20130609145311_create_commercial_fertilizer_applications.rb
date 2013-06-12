class CreateCommercialFertilizerApplications < ActiveRecord::Migration
  def change
    create_table :commercial_fertilizer_applications do |t|

      t.integer :crop_rotation_id

      t.integer :application_date_year
      t.integer :application_date_month
      t.integer :application_date_day

      t.decimal :total_n_applied
      t.decimal :total_p_applied
      t.boolean :is_incorporated

      t.integer :incorporation_date_year
      t.integer :incorporation_date_month
      t.integer :incorporation_date_day

      t.decimal :depth

      t.timestamps
    end
  end
end
