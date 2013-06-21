class CreateFieldTypeBmpTypes < ActiveRecord::Migration
  def change
    create_table :field_type_bmp_types do |t|
      t.integer :field_type_id
      t.integer :bmp_type_id
    end
  end
end
