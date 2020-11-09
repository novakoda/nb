class CreateFriendships < ActiveRecord::Migration[6.0]
  def change
    create_table :friendships do |t|
      t.references :one
      t.references :two

      t.timestamps
    end
    add_foreign_key :friendships, :users, column: :one_id
    add_foreign_key :friendships, :users, column: :two_id
  end
end
