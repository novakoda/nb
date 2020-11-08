class CreateFriendRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :friend_requests do |t|
      t.references :requester
      t.references :requested

      t.timestamps
    end
    add_foreign_key :friend_requests, :users, column: :requester_id
    add_foreign_key :friend_requests, :users, column: :requested_id
  end
end
