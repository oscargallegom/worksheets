class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :tract_number
      t.string :farm_notes
      t.string :site_name
      t.string :site_address_1
      t.string :site_address_2
      t.string :site_city
      t.string :site_zip

      t.belongs_to :user

      t.timestamps
    end
  end
end
