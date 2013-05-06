class CreateTablePTestMethods < ActiveRecord::Migration
  def change
    create_table :p_test_methods do |t|
      t.string :name
      t.timestamps
    end
  end
end
