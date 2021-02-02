class RemoveYtLinkFromPeopleAndAddMiscIdAndIdTypeToPeople < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :misc_id, :string
    add_column :people, :id_type, :integer
    remove_column :people, :yt_link, :string
  end
end
