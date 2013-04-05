class CreateUserType < ActiveRecord::Migration
  def change
    create_table :user_type do |t|
      t.string :name

      t.timestamps
    end
  end
end
