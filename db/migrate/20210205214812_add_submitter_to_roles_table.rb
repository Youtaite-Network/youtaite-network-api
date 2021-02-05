class AddSubmitterToRolesTable < ActiveRecord::Migration[6.0]
  def change
    add_column :roles, :user_id, :integer

    add_foreign_key :roles, :users
    change_column_null(:roles, :user_id, false)
  end
end
