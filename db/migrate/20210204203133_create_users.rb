class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :google_id

      t.timestamps
    end

    add_index :users, :google_id, unique: true
    add_index :collabs, :yt_id, unique: true
    add_index :people, :misc_id, unique: true
    
    change_column_null(:users, :google_id, false)
  end
end
