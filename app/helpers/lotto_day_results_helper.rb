module LottoDayResultsHelper
	def lotto_day_results_path
		{ :controller => "lotto_day_results", :action => :create }
	end
	def lotto_day_result_path( ld )
		{ :controller => "lotto_day_results", :action => :update, :id => @ldr.id, :project_id => @project.identifier, :lotto_day_id => @ldr.lotto_day.id }
	end
end
