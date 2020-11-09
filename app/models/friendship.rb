class Friendship < ApplicationRecord
  belongs_to :one, class_name: 'User'
  belongs_to :two, class_name: 'User'
end
