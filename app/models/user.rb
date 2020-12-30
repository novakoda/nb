require 'open-uri'
require 'uri'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :facebook, :github, :google_oauth2]

  has_many :posts
  has_many :likes
  has_many :comments

  has_many :liked_posts, through: :likes, source: :post

  has_many :in_friend_requests, class_name: "FriendRequest", foreign_key: "requested_id", dependent: :destroy
  has_many :out_friend_requests, class_name: "FriendRequest", foreign_key: "requester_id", dependent: :destroy

  has_many :friendships_a, class_name: 'Friendship', foreign_key: 'one_id'
  has_many :friendships_b, class_name: 'Friendship', foreign_key: 'two_id'

  has_many :friends_a, through: :friendships_a, source: 'two'
  has_many :friends_b, through: :friendships_b, source: 'one'

  has_one_attached :avatar
  # after_commit :add_default_avatar, on: %i[create update]

  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
      user.email = provider_data.info.email
      user.first_name = provider_data.info.first_name
      user.last_name = provider_data.info.last_name
      user.password = Devise.friendly_token[0, 20]
      user.save!
    end
  end

  def self.create_from_github_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
      user.email = provider_data.info.email
      user.first_name = provider_data.info.name.split(" ").first
      user.last_name = provider_data.info.name.split(" ").last
      user.password = Devise.friendly_token[0, 20]
      user.save!
    end
  end

  def full_name
    first_name + " " + last_name
  end

  def friendships
    friendships_a + friendships_b
  end

  def friends
    friends_a + friends_b
  end

  private

  # def add_default_avatar
  #   unless avatar.attached?
  #     avatar.attach(
  #       io: File.open(
  #         Rails.root.join(
  #           'app', 'assets', 'images', 'default_profile.jpg'
  #         )
  #       ),
  #       filename: 'default_profile.jpg',
  #       content_type: 'image/jpg'
  #     )
  #   end
  # end

end
