class CreateLivestockInputMethods < ActiveRecord::Migration
  def change
    create_table :livestock_input_methods do |t|
      t.string :name
    end
  end
end
