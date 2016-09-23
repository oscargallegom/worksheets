class CreateFutureFieldTypes < ActiveRecord::Migration
  def change
    create_table :future_field_types do |t|

      t.timestamps
    end
  end
end
