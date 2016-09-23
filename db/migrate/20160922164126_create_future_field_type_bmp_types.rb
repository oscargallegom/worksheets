class CreateFutureFieldTypeBmpTypes < ActiveRecord::Migration
  def change
    create_table :future_field_type_bmp_types do |t|

      t.integer :future_field_type_id
      t.integer :bmp_type_id
    end
  end
end
