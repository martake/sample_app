class Message < ActiveRecord::Base

  before_save :in_direct_to

  belongs_to :user
  default_scope -> { order( 'created_at DESC' ) }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
  def self.from_users(user)

    where_sql = "user_id = :user_id OR in_direct_to = :user_id "
    where(where_sql, user_id: user.id)
  end
  
  def Message.in_direct_to_key( content )
    direct_key = content.strip.match(/^d @.+?\s/).to_s.strip
    direct_key.slice!(0, 3)
    return direct_key
  end

  private
   
    def in_direct_to
      key = Message.in_direct_to_key( self.content )
      self.in_direct_to = Methods::UserMethods.to_user_id(key)
	  end

end
