class FixSessionImageUrlName < ActiveRecord::Migration
  def change
    rename_column :sessions, :image_url, :thumb_url
  end
end
