class CreateBmp < ActiveRecord::Migration
  def change
    create_table :bmps do |t|
      t.integer :field_id
      t.integer :bmp_type_id
      t.decimal :acres
      t.boolean :is_planned
    end
  end
end
