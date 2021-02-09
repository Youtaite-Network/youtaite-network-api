class AddPersonIdToCollabs < ActiveRecord::Migration[6.0]
  def change
    add_column :collabs, :person_id, :integer
  end
end
