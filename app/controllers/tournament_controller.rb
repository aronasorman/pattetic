
class TournamentController < ApplicationController
	before_filter :authenticate_user!, except: [ :fight ]
	
	def fight
	end
end
