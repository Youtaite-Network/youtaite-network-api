class RemoveUserIdFromRolesTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :roles, :user_id, :integer
  end
end
