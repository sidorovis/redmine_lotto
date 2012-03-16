class LottoBetsController < ApplicationController
	unloadable

	before_filter :find_project, :find_lotto_day, :authorize

	def new
		@lb = LottoBet.new
		@lb.lotto_day = @lotto_day
		@lb.project = @project
	end

	def create
		@lb = LottoBet.new( params[ :lotto_bet ] )
#		lb = @lotto_day.bets.find( @lb.id )
		if ( !@lotto_day.finished && LottoLog.log( @project.id, User.current.id, "Lotto bet created", "Bet: " + @lb.price.to_s + " on " + @lotto_day.day_str ) && @lb.save )
			flash[:notice] = 'Lotto Bet registered'
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @lotto_day.id, :project_id => @project.identifier  }
			end
		else
			flash[:error] = 'Lotto Bet cannot be registered. Possibly timeout for bets.'
			respond_to do |format|
				format.html { render :action => 'new', :lotto_day_id => @lotto_day.id, :project_id => @project.identifier }
			end
		end
	end

	def edit
		if (!@lotto_day)
			flash[ :error ] = "Can't edit lotto bet."
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'index', :project_id => @project.identifier }
			end
		end
		@lb = LottoBet.find( params[ :id ], :conditions => { :project_id => @project.id } )	
	end

	def update
		@lb = LottoBet.find( params[ :id ], :conditions => { :project_id => @project.id } )
		if ( !@lotto_day.finished && LottoLog.log( @project.id, User.current.id, "Lotto bet changed", "Price: " + params[ :lotto_bet ][ :price ].to_s + ", " + @lb.lotto_day.day_str ) && @lb.update_attributes( params[ :lotto_bet ] ))
			flash[:notice] = 'Lotto Bet Updated'
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @lb.lotto_day_id, :project_id => @project.identifier }
			end
		else
			flash[:error] = 'Lotto Bet cannot be update.'
			respond_to do |format|
				format.html { render :action => 'edit', :lotto_day_id => @lb.lotto_day_id, :project_id => @project.identifier }
			end
		end
	end
	def destroy
		@lb = LottoBet.find( params[ :id ], :conditions => { :project_id => @project.id } )

		if ( !@lotto_day.finished && LottoLog.log( @project.id, User.current.id, "Lotto bet destroyed", "Destroyed on" + ", " + @lb.lotto_day.day_str ) && @lb.destroy )
			flash[:notice] = 'Lotto Bet deleted'
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @lotto_day.id, :project_id => @project.identifier }
			end
		else
			flash[:notice] = 'Lotto Bet cannot be deleted'
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @lotto_day.id, :project_id => @project.identifier }
			end
		end
	end

private
	def find_project
		@project = Project.find( params[:project_id] )
	end
	def find_lotto_day
		@lotto_day = LottoDay.find( params[ :lotto_day_id ], :conditions => { :project_id => @project.id } )
	end

end
