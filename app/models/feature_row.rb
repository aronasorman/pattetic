require 'libsvm'
class FeatureRow

  N_ATTACKS_AGO = 7 # how many attacks before are features
  
  # for initialization, gather data from the round that just happened.Must be saved to DB
  def initialize(round)
    rounds_by_user = Round.of_user(round.user)


    # if round is not yet persisted, then get the latest round of the user
    round = rounds_by_user.last unless round.persisted?

    n = rounds_by_user.count >= N_ATTACKS_AGO ? N_ATTACKS_AGO : rounds_by_user.count

    # these are the rounds we will consider as features
    @feature_rounds = rounds_by_user.reverse.take n


    # the user's latest attack is his label
    @label = @feature_rounds.first.player1attack
    @label = ATTACK_TO_NUMERIC[@label]
    # the rest are features
    @features = @feature_rounds.drop(1).map do |round|
      attack = round.player1attack
      ATTACK_TO_NUMERIC[attack]
    end
    # add features that reflect repeated sequence of attacks by user
    previous = nil
    attack_frequency = {1.0 => 0, 2.0 => 0, 3.0 => 0}
    (1..3).each do |attacki|
      attack = attacki.to_f
      @features.each do |current|
        if current == previous and current == attack
          attack_frequency[attack] += 1
        end
        previous = current
      end
    end
    @features << attack_frequency.values
  end

  def label
    @label
  end

  def features
    @features.to_example
  end
  
  ATTACK_TO_NUMERIC = {"rock" => 1.0, "paper" => 2.0, "scissors" => 3.0}
  NUMERIC_TO_ATTACK = {1.0 => "rock", 2.0 => "paper", 3.0 => "scissors"}
end
