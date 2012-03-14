class LottoDaysController < ApplicationController
	unloadable

	before_filter :find_project, :authorize

	def index
		@lotto_days = LottoDay.find( :all, :conditions => { :project_id => @project.id }, :order => :day )
		@lotto_logs = LottoLog.find( :all, :conditions => { :project_id => @project.id }, :order => "id DESC" )

		@new_allowed = check_authorize( 'new' )
		@show_allowed = check_authorize( 'show' )
	end
	def show
		@ld = LottoDay.find( params[ :id ], :conditions => { :project_id => @project.id }  )
		@lotto_bets = @ld.lotto_bets.find( :all, :conditions => { :project_id => @project.id }  )

		@edit_allowed = check_authorize( 'edit' )

		@add_day_result_allowed = check_authorize( 'new', 'lotto_day_results' )
		@administrate_day_result_allowed = check_authorize( 'edit', 'lotto_day_results' )

		@administrate_own_bet = false
		if ( check_authorize( 'new', 'lotto_bets' ) && !@ld.lotto_day_result && !@ld.finished )
			@administrate_own_bet = true
		end
	
		@my_lotto_bet = LottoBet.find( :first, :conditions => { :user_id => User.current.id, :lotto_day_id => @ld.id, :project_id => @project.id } )
	end
	def new
		@ld = LottoDay.new( :project_id => @project.id )
	end
	def create
		@ld = LottoDay.new( params[ :lotto_day ] )
		if ( LottoLog.log( @project.id, User.current.id, "Lotto day created", "Date: " + @ld.day_str + " finished set to: " + @ld.finished.to_s ) && @ld.save)
			flash[:notice] = 'Lotto Day created'
			respond_to do |format|
				format.html { redirect_to :action => 'show',  :id => @ld.id, :project_id => @project.identifier }
			end
		else
			flash[:error] = 'Lotto Day cannot be created.'
			respond_to do |format|
				format.html { render :action => 'new', :project_id => @project.identifier }
			end
		end
	end
	def edit
		@ld = LottoDay.find( params[ :id ] )
		if @ld.lotto_day_result
			flash[ :error ] = "Day could not be edited, it have day result"
			respond_to do |format|
				format.html { redirect_to :action => 'show', :id => @ld.id, :project_id => @project.identifier }
			end
		end
	end
	def finish_day
		@ld = LottoDay.find( params[ :id ] )
		if @ld.lotto_day_result
			flash[ :error ] = "Day could not be edited, it have day result"
			respond_to do |format|
				format.html { redirect_to :action => 'show', :id => @ld.id, :project_id => @project.identifier }
			end
		else
			@ld.finished = true
			if ( LottoLog.log( @project.id, User.current.id, "Lotto day set to finished", "Date: " + @ld.day_str ) && @ld.save )
				flash[ :notice ] = "Day closed"
			else
				flash[ :error ] = "Day cannot be closed"
			end
			respond_to do |format|
				format.html { redirect_to :action => 'show', :id => @ld.id, :project_id => @project.identifier }
			end
		end
	end

	def update
		@ld = LottoDay.find( params[ :id ] )
		if @ld.lotto_day_result
			flash[ :error ] = "Day could not be edited, it finished or it have day result"
			respond_to do |format|
				format.html { redirect_to :action => 'show', :id => @ld.id, :project_id => @project.identifier }
			end
		end
		date = params[ :lotto_day ][ "day(3i)" ]+"/"+params[ :lotto_day ][ "day(2i)" ]+"/"+params[ :lotto_day ][ "day(1i)" ]
		if ( LottoLog.log( @project.id, User.current.id, "Lotto day edited", "Old Date: " + @ld.day_str + " New Date:" + date.to_s + " finished set to: " + (params[ :lotto_day ][ :finished ] == "1").to_s ) && @ld.update_attributes( params[ :lotto_day ] ) )
			flash[:notice] = 'Lotto Day updated'
			respond_to do |format|
				format.html { redirect_to :action => 'show',  :id => @ld.id, :project_id => @project.identifier }
			end
		else
			flash[:error] = 'Lotto Day cannot be update.'
			respond_to do |format|
				format.html { render :action => 'edit', :project_id => @project.identifier }
			end
		end
	end

	def destroy
		@ld = LottoDay.find( params[ :id ] )
		if @ld.lotto_day_result || @ld.finished
			flash[ :error ] = "Day could not be deleted, it finished or have day result"
			respond_to do |format|
				format.html { redirect_to :action => 'show',  :id => @ld.id, :project_id => @project.identifier }
			end
		else
			if ( LottoLog.log( @project.id, User.current.id, "Lotto day destroyed", "Date: " + @ld.day_str + " finished set to: " + @ld.finished.to_s ) && @ld.destroy )
				flash[:notice] = 'Lotto Day deleted'
			else
				flash[:notice] = 'Lotto Day cannot be deleted'
			end
			redirect_to :action => 'index', :project_id => @project.identifier
		end
	end

private
	def check_authorize( action, ctrl = params[:controller] )
		global = true
    	allowed = User.current.allowed_to?( {:controller => ctrl, :action => action }, @project || @projects, :global => global)
	end
	def find_project
		@project = Project.find( params[:project_id] )
	end
end
