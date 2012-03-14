class LottoDayResultsController < ApplicationController
	unloadable

	before_filter :find_project, :find_lotto_day, :authorize

	def index
		respond_to do |format|
			format.html { redirect_to :controller => 'lotto_days', :action => 'index', :project_id => @project.identifier }
		end
	end

	def new
		if (!@lotto_day || !@lotto_day.finished)
			flash[ :error ] = "Can't create lotto day result, it should be finished."
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'index', :project_id => @project.identifier  }
			end
		end
		@ldr = LottoDayResult.new
		@ldr.lotto_day = @lotto_day
		@ldr.project = @project
	end

	def create
		@ldr = LottoDayResult.new( params[ :lotto_day_result ] )
		if ( @lotto_day.finished && LottoLog.log( @project.id, User.current.id, "Lotto day result registered", "Price: " + @ldr.price.to_s + ", " + @ldr.lotto_day.day_str ) && @ldr.save)
			flash[:notice] = 'Lotto Day Result registered'
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @lotto_day.id, :project_id => @project.identifier  }
			end
		else
			flash[:error] = 'Lotto Day Result cannot be registered. Possibly it should be finished first.'
			respond_to do |format|
				format.html { render :action => 'new', :lotto_day_id => @lotto_day.id, :project_id => @project.identifier }
			end
		end
	end

	def edit
		if (!@lotto_day)
			flash[ :error ] = "Can't edit lotto day result."
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'index', :project_id => @project.identifier }
			end
		end
		@ldr = LottoDayResult.find( params[ :id ], :conditions => { :project_id => @project.id } )	
	end
	def update
		@ldr = LottoDayResult.find( params[ :id ], :conditions => { :project_id => @project.id } )
		if ( LottoLog.log( @project.id, User.current.id, "Lotto day result changed", "Price: " + params[ :lotto_day_result ][ :price ].to_s + ", " + @ldr.lotto_day.day_str ) && @ldr.update_attributes( params[ :lotto_day_result ] ))
			flash[:notice] = 'Lotto Day Result Updated'
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @ldr.lotto_day_id, :project_id => @project.identifier }
			end
		else
			flash[:error] = 'Lotto Day Result cannot be update.'
			respond_to do |format|
				format.html { render :action => 'edit', :lotto_day_id => @ldr.lotto_day_id, :project_id => @project.identifier }
			end
		end
	end
	def destroy
		@ldr = LottoDayResult.find( params[ :id ], :conditions => { :project_id => @project.id } )

		if ( LottoLog.log( @project.id, User.current.id, "Lotto day result destroyed", "Destroyed on" + ", " + @ldr.lotto_day.day_str ) && @ldr.destroy )
			flash[:notice] = 'Lotto Day Result deleted'
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @lotto_day.id, :project_id => @project.identifier }
			end
		else
			flash[:notice] = 'Lotto Day Result cannot be deleted'
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
