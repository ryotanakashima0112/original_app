class Room < ApplicationRecord
  belongs_to :battle
  has_many :comments
end
