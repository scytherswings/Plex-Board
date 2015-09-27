class AddPasswordDigestToService < ActiveRecord::Migration
  def change
    add_column :services, :password_digest, :string
  end
end
