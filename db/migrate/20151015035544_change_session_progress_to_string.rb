class ChangeSessionProgressToString < ActiveRecord::Migration
  def change
    change_column :sessions, :progress, :string
  end
end
