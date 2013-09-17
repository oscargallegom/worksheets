class CreateFutureBmps < ActiveRecord::Migration
  def change
    create_table :future_bmps do |t|
      t.integer :field_id
      t.integer :bmp_type_id
      t.boolean :is_planned
    end
  end
end
