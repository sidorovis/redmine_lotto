class LottoDayResultsController < ApplicationController
	unloadable

	before_filter :find_project, :authorize

	def index
		respond_to do |format|
			format.html { redirect_to :controller => 'lotto_days', :action => 'index', :project_id => @project.identifier }
		end
	end

	def new
		ld = LottoDay.find( params[ :lotto_day_id ] )
		if (!ld || !ld.finished)
			flash[ :error ] = "Can't create lotto day result, it should be finished."
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'index', :project_id => @project.identifier  }
			end
		end
		@ldr = LottoDayResult.new
		@ldr.lotto_day = ld
	end

	def create
		@ldr = LottoDayResult.new( params[ :lotto_day_result ] )
		if ( @ldr.lotto_day.finished && @ldr.save)
		    @news = News.new(:project => @project, :author => User.current)
			@news.title = "Lotto day result registered"
			@news.description = "Price: " + @ldr.price.to_s
			@news.save
			flash[:notice] = 'Lotto Day Result registered'
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => @ldr.lotto_day_id, :project_id => @project.identifier  }
			end
		else
			flash[:error] = 'Lotto Day Result cannot be registered. Possibly it should be finished first.'
			respond_to do |format|
				format.html { render :action => 'new', :lotto_day_id => @ldr.lotto_day_id, :project_id => @project.identifier }
			end
		end
	end

	def edit
		ld = LottoDay.find( params[ :lotto_day_id ] )
		if (!ld)
			flash[ :error ] = "Can't edit lotto day result."
			respond_to do |format|
				format.html { redirect_to :controller => 'lotto_days', :action => 'index', :project_id => @project.identifier }
			end
		end
		@ldr = LottoDayResult.find( params[ :id ] )	
	end
	def update
		@ldr = LottoDayResult.find( params[ :id ] )
		if (@ldr.update_attributes( params[ :lotto_day_result ] ))
		    @news = News.new(:project => @project, :author => User.current)
			@news.title = "Lotto day result changed"
			@news.description = "Price: " + @ldr.price.to_s
			@news.save

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
		@ldr = LottoDayResult.find( params[ :id ] )
		lotto_day_result_id = @ldr.lotto_day_id
		@ldr.destroy
	    @news = News.new(:project => @project, :author => User.current)
		@news.title = "Lotto day result destroyed"
		@news.description = "Destroyed"
		@news.save

		flash[:notice] = 'Lotto Day Result deleted'
		respond_to do |format|
			format.html { redirect_to :controller => 'lotto_days', :action => 'show', :id => lotto_day_result_id, :project_id => @project.identifier }
		end
	end

private
	def find_project
		@project = Project.find( params[:project_id] )
	end
end
