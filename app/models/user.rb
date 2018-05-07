class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :strength, presence: true
  validates :introduce, length: { maximum: 255 }
  validates :address, length: { maximum: 50 }
  has_secure_password
  
  has_many :battles
  has_many :requestings, through: :battles, source: :match
  has_many :reverses_of_battle, class_name: 'Battle', foreign_key: 'match_id'
  has_many :requesters, through: :reverses_of_battle, source: :user

  def request_battle_to(other_user)
    unless self == other_user
      battle = self.battles.find_or_create_by(match_id: other_user.id, doing: false)
      battle.status = 0
      battle.save
    end
  end
  

  def refuse_battle_from(other_user)
    battle = other_user.battles.find_by(match_id: self.id, doing: false)
    battle.status = 2
    battle.save
  end
  
  def refuse_battle_to(other_user)
    battle = self.battles.find_by(match_id: other_user.id, doing: false)
    battle.destroy if battle
  end

  def request_battle_to?(other_user)
    self.requestings.where(battles: {status: 0, doing: false}).include?(other_user)
  end
  
  def accept_battle_from?(other_user)
    self.requesters.where(battles: {status: 0, doing: false}).include?(other_user)
  end
  
  def match_battle?(other_user)
    battle =  self.battles.find_by(match_id: other_user.id, doing: false)
    battle.status == 1 if battle
  end
  
  def accept_battle_from(other_user)
    battle = other_user.battles.find_by(match_id: self.id)
    battle.status = 1
    battle.save
  end
  
  def done_battle?(other_user)
    battle = self.battles.find_by(match_id: other_user)
    battle.doing == true if battle
  end
  
  def count_match(user_id)
    count = self.battles.where("user_id =? and match_id =?", self.id, user_id).count
    count2 = self.battles.where("user_id =? and match_id =?", user_id, self.id).count
    return count + count2
  end
    
end
