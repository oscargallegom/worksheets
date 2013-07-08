class CreatePoultry < ActiveRecord::Migration
  def change
    create_table :poultry do |t|
      t.string :name
    end
  end
end
