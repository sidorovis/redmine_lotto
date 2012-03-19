class LottoBetsController < ApplicationController
	unloadable

	before_filter :find_project, :find_lotto_day, :authorize

	def new
		@lb = LottoBet.new
		@lb.lotto_day = @lotto_day
		@lb.project = @project
		lb = @lotto_day.lotto_bets.find( :first, :conditions => { :project_id => @project.id, :user_id => User.current.id } )
		if (lb)
			LottoLog.log( @project.id, User.current.id, "!! Hacker Warning", "Trying to create additional bet." )
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @lotto_day.id, :project_id => @project.identifier }
			end
		end
	end

	def create
		lb = @lotto_day.lotto_bets.find( :first, :conditions => { :project_id => @project.id, :user_id => User.current.id } )
		@lb = LottoBet.new( params[ :lotto_bet ] )
		if (lb)
			LottoLog.log( @project.id, User.current.id, "!! Hacker Warning", "Trying to create additional bet: " + @lb.price.to_s + " on " + @lotto_day.day_str )
			flash[:error] = 'Lotto Bet cannot be registered. Your bet had been created.'
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @lotto_day.id, :project_id => @project.identifier }
			end
		elsif ( !@lotto_day.finished && LottoLog.log( @project.id, User.current.id, "Lotto bet created", "Bet: " + @lb.price.to_s + " on " + @lotto_day.day_str ) && @lb.save )
			flash[:notice] = 'Lotto Bet registered.'
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @lotto_day.id, :project_id => @project.identifier  }
			end
		else
			flash[:error] = 'Lotto Bet cannot be registered. Possibly timeout for bets.'
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @lotto_day.id, :project_id => @project.identifier }
			end
		end
	end

	def edit
		if (!@lotto_day || @lotto_day.finished)
			flash[ :error ] = "Can't edit lotto bet."
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'index', :project_id => @project.identifier }
			end
		else
			@lb = LottoBet.find_by_id( params[:id], :conditions => { :project_id => @project.id, :user_id => User.current.id, :lotto_day_id => @lotto_day.id } )
			if (!@lb)		
				LottoLog.log( @project.id, User.current.id, "!! Hacker Warning", "Trying to edit bet." )
				flash[ :error ] = "Can't edit lotto bet."
				respond_to do |format|
					format.html { redirect_to :controller => 'lotto_days', :action => 'index', :project_id => @project.identifier }
				end
			end
		end
	end

	def update
		lb = LottoBet.find_by_id( params[:id], :conditions => { :project_id => @project.id, :user_id => User.current.id, :lotto_day_id => @lotto_day.id } )
		if (!lb)
			LottoLog.log( @project.id, User.current.id, "!! Hacker Warning", "Trying to update bet." )
			flash[:error] = 'Lotto Bet cannot be update.'
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @lotto_day.id, :project_id => @project.identifier }
			end
		else
			@lb = LottoBet.find( params[ :id ], :conditions => { :project_id => @project.id, :user_id => User.current.id, :lotto_day_id => @lotto_day.id } )
			if ( @lb && !@lotto_day.finished && params[ :lotto_bet ] )
				if ( LottoLog.log( @project.id, User.current.id, "Lotto bet changed", "Price: " + params[ :lotto_bet ][ :price ].to_s + ", " + @lb.lotto_day.day_str ) && @lb.update_attributes( params[ :lotto_bet ] ))
					flash[:notice] = 'Lotto Bet Updated.'
					respond_to do |format|
						format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @lotto_day.id, :project_id => @project.identifier }
					end
				else
					flash[:error] = 'Lotto Bet cannot be update.'
					respond_to do |format|
						format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @lotto_day.id, :project_id => @project.identifier }
					end
				end
			else
				LottoLog.log( @project.id, User.current.id, "!! Hacker Warning", "Trying to update bet." )
				flash[:error] = 'Lotto Bet cannot be update.'
				respond_to do |format|
					format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @lotto_day.id, :project_id => @project.identifier }
				end
			end
		end
	end
	def destroy
		@lb = LottoBet.find_by_id( params[ :id ], :conditions => { :project_id => @project.id, :user_id => User.current.id, :lotto_day_id => @lotto_day.id } )
		if ( @lb && !@lotto_day.finished && LottoLog.log( @project.id, User.current.id, "Lotto bet destroyed", "Destroyed on" + ", " + @lb.lotto_day.day_str ) && @lb.destroy )
			flash[:notice] = 'Lotto Bet deleted.'
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @lotto_day.id, :project_id => @project.identifier }
			end
		else
			LottoLog.log( @project.id, User.current.id, "!! Hacker Warning", "Destroying unexisted bet" )
			flash[:error] = 'Lotto Bet cannot be deleted.'
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
