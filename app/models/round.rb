require 'libsvm'
class Round < ActiveRecord::Base
  attr_accessible :player1attack, :player2attack, :user_id, :round_type

  has_one :feature_row
  belongs_to :user

  ATTACKS = %w{rock paper scissors}
  ROUND_TYPES = %w{real seed}

  validates :player1attack, inclusion: {in: ATTACKS, allow_blank: true}
  validates :player2attack, inclusion: {in: ATTACKS, allow_blank: true}

  validates :round_type, inclusion: {in: ROUND_TYPES}

  scope :of_user, -> user { where(user_id: user.id) }
  scope :real, -> { where(round_type: "real") }

  def to_example
    values = attributes.map {|key, val| val}
    values.to_example
  end

  def feature_row
    FeatureRow.new self
  end

  def determine_winner
    case [player1attack, player2attack]
    when ["rock", "paper"], ["paper", "scissors"], ["scissors", "rock"]
      :player1
    when [player1attack, player1attack]
      nil
    else
      :player2
    end
  end
end

class Array
  def ===(other)
    return false if (other.size != self.size)

    other_dup = other.dup
    all? do |e|
      e === other_dup.shift
    end
  end
end
