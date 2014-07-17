class AddReplayToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :in_replay_to, :integer
    add_index :microposts, [:in_replay_to]
    add_index :users, [:key]
  end
end
