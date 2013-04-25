class CreateLivestocks < ActiveRecord::Migration
  def change
    create_table :livestocks do |t|
      t.decimal :animal_units
      t.integer :animal_id
    end
  end
end
