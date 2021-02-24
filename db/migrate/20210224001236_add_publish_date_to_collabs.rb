class AddPublishDateToCollabs < ActiveRecord::Migration[6.0]
  def change
    add_column :collabs, :published_at, :datetime
  end
end
