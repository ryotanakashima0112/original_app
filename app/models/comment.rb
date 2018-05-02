class Comment < ApplicationRecord
  belongs_to :room
  
  validates :room_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }
  validates :from_id, presence: true
  validates :to_id, presence: true
end
