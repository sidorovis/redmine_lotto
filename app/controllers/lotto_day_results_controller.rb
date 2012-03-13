class LottoDayResultsController < ApplicationController
	unloadable

	before_filter :authorize_global

	def index
		respond_to do |format|
			format.html { redirect_to :controller => 'lotto_days', :action => 'index' }
		end
	end

	def new
		ld = LottoDay.find( params[ :lotto_day_id ] )
		if (!ld)
			flash[ :error ] = "Can't create lotto day result."
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'index' }
			end
		end
		@ldr = LottoDayResult.new
		@ldr.lotto_day = ld
	end

	def create
		@ldr = LottoDayResult.new( params[ :lotto_day_result ] )
		if (@ldr.save)
			flash[:notice] = 'Lotto Day Result registered'
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'show',  :id => @ldr.lotto_day_id }
			end
		else
			flash[:error] = 'Lotto Day Result cannot be registered.'
			respond_to do |format|
				format.html { render :action => 'new', :lotto_day_id => @ldr.lotto_day_id }
			end
		end
	end
end
