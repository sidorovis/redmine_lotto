class LottoDaysController < ApplicationController
	unloadable

	before_filter :find_project, :authorize

	def index
		@lotto_days = LottoDay.find(:all, :order => :day)
		@show_allowed = check_authorize( 'show' )
		@new_allowed = check_authorize( 'new' )
	end
	def show
		@ld = LottoDay.find( params[ :id ] )
		@lotto_bets = @ld.lotto_bets.find(:all)
		@day_result = @ld.lotto_day_result
		@edit_allowed = check_authorize( 'edit' )
		@add_day_result_allowed = check_authorize( 'new', 'lotto_day_results' )
		@administrate_day_result_allowed = check_authorize( 'edit', 'lotto_day_results' )
	end
	def new
		@ld = LottoDay.new()
	end
	def create
		@ld = LottoDay.new( params[ :lotto_day ] )
		if ( @ld.save )
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

	def update
		@ld = LottoDay.find( params[ :id ] )
		if (@ld.update_attributes( params[ :lotto_day ] ))
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
		if @ld.lotto_day_result 
			flash[ :error ] = "Day could not be deleted, it have day result"
			respond_to do |format|
				format.html { redirect_to :action => 'show',  :id => @ld.id, :project_id => @project.identifier }
			end
		else
			@ld.destroy
			flash[:notice] = 'Lotto Day deleted'
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
