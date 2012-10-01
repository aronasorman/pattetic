require 'libsvm'

class SvmPlayer
  def initialize
    @problem = Libsvm::Problem.new
    @param = Libsvm::SvmParameter.new
    @param.cache_size = 3 # MB
    @param.eps = 0.001
    @param.c = 10
  end

  def train
    rounds = Round.real.reverse.drop(1) # the last attack is our input for prediction
    feature_rows = rounds.map(&:feature_row)
    labels = []
    examples = []
    feature_rows.each do |row|
      labels << row.label
      examples << row.features
    end
    puts "labels are #{labels}"
    puts "examples are #{examples}"
    puts "something should've printed"
    @problem.set_examples(labels, examples)
    @model = Libsvm::Model.train(@problem, @param)
  end

  def predict_user_attack
    round = Round.last.feature_row # our basis for prediction
    prediction = @model.predict(round.features)
    puts "numeric prediction is #{prediction}"
    FeatureRow::NUMERIC_TO_ATTACK[prediction]
  end

  def attack
    train
    prediction = predict_user_attack
    puts "prediction is #{prediction}"

    # if svm's response doesn't make sense, choose random attack
    user_attack_to_response = Hash.new do
      puts "randomizing attack"
      Round::ATTACKS[rand(0..2)]
    end
    user_attack_to_response["rock"] = "paper"
    user_attack_to_response["paper"] = "scissors"
    user_attack_to_response["scissors"] = "rock"
    
    user_attack_to_response[prediction]
  end
end
