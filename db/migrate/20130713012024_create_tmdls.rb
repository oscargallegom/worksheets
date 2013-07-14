class CreateTmdls < ActiveRecord::Migration
  def change
    create_table :tmdls do |t|
      t.string :name
      t.decimal :total_n
      t.decimal :total_p
    end
  end
end
