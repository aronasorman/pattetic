
class RoundsController < ApplicationController
  # GET /rounds
  # GET /rounds.json

  before_filter :authenticate_user!


  def index
    @rounds = Round.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rounds }
    end
  end

  # GET /rounds/1
  # GET /rounds/1.json
  def show
    @round = Round.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @round }
    end
  end

  # GET /rounds/new
  # GET /rounds/new.json
  def new
    @round = Round.new(round_type: "real")

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @round }
    end
  end

  # POST /rounds
  # POST /rounds.json
  def create
    @round = Round.new(params[:round])


    svmplayer = SvmPlayer.new # inefficient, i know
    @round.player2attack = svmplayer.attack

    message = case @round.determine_winner
    when :player1
      "you won the last round!"
    when :player2
      "you lost!"
    else
      "it was a draw!"
    end
    
    respond_to do |format|
      if @round.save
        format.html { redirect_to new_round_path, notice: message }
        format.json { render json: @round, status: :created, location: @round }
      else
        format.html { render action: "new" }
        format.json { render json: @round.errors, status: :unprocessable_entity }
      end
    end
  end
end
