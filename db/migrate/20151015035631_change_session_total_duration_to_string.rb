class ChangeSessionTotalDurationToString < ActiveRecord::Migration
  def change
    change_column :sessions, :total_duration, :string
  end
end
