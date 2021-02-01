class CreatePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :people do |t|
      t.string :yt_link

      t.timestamps
    end
  end
end
