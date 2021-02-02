class AddTitleAndThumbnailToCollabs < ActiveRecord::Migration[6.0]
  def change
    add_column :collabs, :title, :string
    add_column :collabs, :thumbnail, :string
  end
end
