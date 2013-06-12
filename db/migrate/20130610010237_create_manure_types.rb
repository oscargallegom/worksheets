class CreateManureTypes < ActiveRecord::Migration
  def change
    create_table :manure_types do |t|
      t.string :name
      t.string :category
    end
  end
end
