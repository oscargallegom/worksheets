class CreateProjectsHaveAndBelongToManyAnimals < ActiveRecord::Migration
  def up
    create_table :projects_animals, :id => false do |t|
      t.references :farm, :animal
    end
  end

  def down
    drop_table :projects_animals
  end
end
