class AddAddedDateToPlexRecentlyAdded < ActiveRecord::Migration[4.2]
  def change
    create_table :plex_recently_addeds do |t|
      t.datetime :added_date

      t.timestamps null:false
    end
  end
end
