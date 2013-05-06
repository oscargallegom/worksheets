class CreateGeneratorTypes < ActiveRecord::Migration
  def change
    create_table :generator_types do |t|
      t.string :name
    end
    add_column :farms, :generator_type_id, :integer
  end
end
