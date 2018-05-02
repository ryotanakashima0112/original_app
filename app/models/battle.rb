class Battle < ApplicationRecord
  belongs_to :user
  belongs_to :match, class_name: "User"
  has_one :room
  
  validates :user_id, presence: true
  validates :match_id, presence: true
end
