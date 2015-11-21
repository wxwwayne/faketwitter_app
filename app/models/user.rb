class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
    foreign_key: "follower_id",
    dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship",
    foreign_key: "followed_id",
    dependent: :destroy
  has_many :followers, through: :passive_relationships
  attr_accessor :remember_token, :activation_token, :reset_token, :authentication_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, length: {minimum: 6}, allow_blank: true

  #api authentication
  before_create :generate_authentication_token

  #return digest of certain string
  def User.digest(string)
    cost= ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  #to memeorize user in db for session
  #this is a instance method invoked by user.remember~~~
  #do not get confused with the helper remember() method!
    #by the way remember(user) = remember user~~~
    def remember
      self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest(remember_token))
    end

    def forget
      update_attribute(:remember_digest, nil)
    end

    def authenticated?(attribute, token)
      digest = send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end

    def activate
      update_attributes(activated: true, activated_at: Time.zone.now)
    end

    def send_activation_email
      UserMailer.account_activation(self).deliver_now
    end

    def create_reset_digest
      self.reset_token = User.new_token
      #update_attribute(:reset_digest, User.digest(reset_token))
      #update_attribute(:reset_sent_at, Time.zone.now)
      update_attributes(reset_digest: User.digest(reset_token),
                        reset_sent_at: Time.zone.now)
    end

    def send_password_reset_email
      UserMailer.password_reset(self).deliver_now
    end

    def feed
      following_ids = "SELECT followed_id FROM relationships
                            WHERE follower_id = :user_id"
      Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id",
                      user_id: self.id)
    end
    #follow another user
    def follow(other_user)
      active_relationships.create(followed_id: other_user.id)
    end

    def unfollow(other_user)
      active_relationships.find_by(followed_id: other_user.id).destroy
    end

    def following?(other_user)
      following.include?(other_user)
    end

    def followed_by?(other_user)
      followers.include?(other_user)
    end


    private
    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def generate_authentication_token
      loop do
        self.authentication_token = SecureRandom.base64(64)
        break unless User.find_by(authentication_token: authentication_token)
      end
    end
  end
