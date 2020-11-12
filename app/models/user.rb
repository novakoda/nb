class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts

  has_many :in_friend_requests, class_name: "FriendRequest", foreign_key: "requested_id", dependent: :destroy
  has_many :out_friend_requests, class_name: "FriendRequest", foreign_key: "requester_id", dependent: :destroy

  has_many :friendships_a, class_name: 'Friendship', foreign_key: 'one_id'
  has_many :friendships_b, class_name: 'Friendship', foreign_key: 'two_id'

  has_many :friends_a, through: :friendships_a, source: 'two'
  has_many :friends_b, through: :friendships_b, source: 'one'

  def full_name
    first_name + " " + last_name
  end

  def friends
    friends_a + friends_b
  end
end
