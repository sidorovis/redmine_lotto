class LottoDaysController < ApplicationController
	unloadable

	before_filter :authorize_global

	def index
		@lotto_days = LottoDay.find(:all)
		@show_allowed = check_authorize( 'show' )
		@new_allowed = check_authorize( 'new' )
	end
	def show
		id = params[ :id ]
		@ld = LottoDay.find( id )
		@lotto_bets = LottoBet.find(:all)
		@day_result = @ld.lotto_day_result
	end
	def new
		@ld = LottoDay.new
	end

private
	def check_authorize( action = params[:action] )
		ctrl = params[:controller]
		global = true
    	allowed = User.current.allowed_to?({:controller => ctrl, :action => action}, @project || @projects, :global => global)
	end
end
