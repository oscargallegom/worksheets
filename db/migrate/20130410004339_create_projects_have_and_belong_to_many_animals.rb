class CreateProjectsHaveAndBelongToManyAnimals < ActiveRecord::Migration
  def up
    create_table :projects_animals, :id => false do |t|
      t.references :project, :animal
    end
  end

  def down
    drop_table :projects_animals
  end
end
