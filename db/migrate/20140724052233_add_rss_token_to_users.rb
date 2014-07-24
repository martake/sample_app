class AddRssTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rss_token, :string
    add_index :users, :rss_token
  end
end
