class CreateGrazingLivestocks < ActiveRecord::Migration
  def change
    create_table :grazing_livestocks do |t|

      t.integer :crop_rotation_id

      t.integer :start_date_year
      t.integer :start_date_month
      t.integer :start_date_day

      t.integer :end_date_year
      t.integer :end_date_month
      t.integer :end_date_day

      t.integer :animal_id

      t.decimal :animal_units
      t.decimal :hours_grazed

      t.boolean :precision_feeding

      t.timestamps
    end
  end
end
