class Micropost < ActiveRecord::Base

  before_save :in_replay_to

  belongs_to :user
  default_scope -> { order( 'created_at DESC' ) }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"

    where_sql = "user_id IN (#{followed_user_ids}) OR user_id = :user_id OR in_replay_to = :user_id "

    where(where_sql, user_id: user.id)
  end
  
  private
   
    def in_replay_to

      replay_key = self.content.strip.match(/^@.+?\s/).to_s.strip
      replay_key.slice!(0)
      self.in_replay_to = Methods::UserMethods.to_user_id(replay_key)
    
	  end

end
