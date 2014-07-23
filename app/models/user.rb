class User < ActiveRecord::Base

  has_many :microposts, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", 
                           dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", 
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }, :on => :create

  has_secure_password
  validates :password, length: { minimum: 6 }

  VALID_KEY_REGEX = /[0-9a-z\d\-\_.]/i
  validates :key, presence: true, length: { minimum: 6 },
                    format: { with: VALID_KEY_REGEX },
                    uniqueness: { case_sensitive: false }, :on => :create

  state_machine :mail_confirm_state, :initial => :wait do
    state :wait
    state :ok

    # event :confirmed do
    #   transition :wait => :ok
    # end

  end

  def confirmed
    update_attribute( :mail_confirm_state, "ok")
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def feed_direct
    Message.from_users(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def send_password_reset
    update_attribute(:password_reset_token, SecureRandom.urlsafe_base64)
    update_attribute(:password_reset_sent_at, Time.zone.now)

    UserMailer.password_reset(self).deliver
  end

  def send_email_confirm
     update_attribute(:email_confirm_token, SecureRandom.urlsafe_base64)

     UserMailer.email_confirm(self).deliver

  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end


end
