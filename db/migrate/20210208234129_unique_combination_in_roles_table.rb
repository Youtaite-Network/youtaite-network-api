class UniqueCombinationInRolesTable < ActiveRecord::Migration[6.0]
  def change
    add_index :roles, [:collab_id, :person_id, :role], unique: true
  end
end
