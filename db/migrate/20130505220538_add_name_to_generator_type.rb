class AddNameToGeneratorType < ActiveRecord::Migration
  def change
    add_column :generator_types, :name, :string
  end
end
