class ChangeGoogleIdToAltIdAndAddIdType < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :google_id, :alt_user_id
    add_column :users, :id_type, :integer
  end
end
