class CreateBmpType < ActiveRecord::Migration
  def change
    create_table :bmp_types do |t|
      t.string :name
    end
  end
end
