class CreateManureConsistencies < ActiveRecord::Migration
  def change
    create_table :manure_consistencies do |t|
      t.string :name
    end
  end
end
