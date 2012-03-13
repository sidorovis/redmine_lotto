module LottoDaysHelper
	def lotto_days_path
		{ :controller => "lotto_days", :action => :create, :project_id => @project.identifier}
	end
	def lotto_day_path( ld )
		{ :controller => "lotto_days", :action => :update, :id => ld.id, :project_id => @project.identifier }
	end
end
