class AddFipsToCounties < ActiveRecord::Migration
  def change
    add_column :counties, :fips, :integer
  end
end
