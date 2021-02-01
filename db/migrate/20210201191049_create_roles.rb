class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.integer :person_id
      t.integer :collab_id
      t.integer :role

      t.timestamps
    end

    add_foreign_key :roles, :people
    add_foreign_key :roles, :collabs
    change_column_null(:roles, :person_id, false)
    change_column_null(:roles, :collab_id, false)
  end
end
