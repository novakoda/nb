class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts

  has_many :in_friend_requests, class_name: "FriendRequest", foreign_key: "requested_id", dependent: :destroy
  has_many :out_friend_requests, class_name: "FriendRequest", foreign_key: "requester_id", dependent: :destroy

  has_many :friendships, foreign_key: 'one_id'
  has_many :friendships, foreign_key: 'two_id'

  has_many :friends, through: :friendships, source: 'one'
  has_many :friends, through: :friendships, source: 'two'

  def full_name
    first_name + " " + last_name
  end
end
