class AddAbbreviationToState < ActiveRecord::Migration
  def change
    add_column :states, :abbreviation, :string
  end
end
