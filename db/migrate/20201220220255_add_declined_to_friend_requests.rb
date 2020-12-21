class AddDeclinedToFriendRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :friend_requests, :declined, :boolean, default: false
  end
end
