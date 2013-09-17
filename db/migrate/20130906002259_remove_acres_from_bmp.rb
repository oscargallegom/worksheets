class RemoveAcresFromBmp < ActiveRecord::Migration
  def change
    remove_column :bmps, :acres
  end

end
