class Round < ActiveRecord::Base
  attr_accessible :player1attack, :player2attack, :user_id
  
  ATTACKS = %w{rock paper scissors}
end
