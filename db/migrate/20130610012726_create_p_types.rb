class CreatePTypes < ActiveRecord::Migration
  def change
    create_table :p_types do |t|
      t.string :name
    end
  end
end
