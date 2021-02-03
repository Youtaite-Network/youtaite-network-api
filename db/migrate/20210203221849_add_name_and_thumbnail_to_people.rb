class AddNameAndThumbnailToPeople < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :name, :string
    add_column :people, :thumbnail, :string
  end
end
