class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
  :provider, :uid, :name
  # attr_accessible :title, :body

  has_many :rounds
  has_many :feature_rows

  after_create :create_initial_rounds # to start off the svm with seed data


  def self.find_for_facebook_oauth(auth, signed_in_resource = nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
      provider:auth.provider,
      uid:auth.uid,
      email:auth.info.email,
      password:Devise.friendly_token[0, 20]
      )
    end
    user
  end

  private
  def create_initial_rounds
    # the cartesian product of all possible player1 and 2 attacks
    Round::ATTACKS.each do |player2attack|
      Round::ATTACKS.each do |player1attack|
        Round.create(player1attack: player1attack,
        player2attack: player2attack,
        user_id: id,
        round_type: "seed"
        )
      end
    end
  end
end
