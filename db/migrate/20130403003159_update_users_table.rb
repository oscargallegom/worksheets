class UpdateUsersTable < ActiveRecord::Migration
  def up

    change_table :users do |t|

      t.rename :email, :username
      t.integer :user_type_id
      t.string :phone
      t.string :street1
      t.string :street2
      t.string :city
      t.integer :state_id
      t.string :zip

      t.string :org_name
      t.string :job_title
      t.string :org_street1
      t.string :org_street2
      t.string :org_city
      t.integer :org_state_id
      t.string :org_zip

    end
  end
end

