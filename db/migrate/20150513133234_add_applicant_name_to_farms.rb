class AddApplicantNameToFarms < ActiveRecord::Migration
  def change
    add_column :farms, :application_name, :string
  end
end
