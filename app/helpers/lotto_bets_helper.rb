module LottoBetsHelper
	def lotto_bets_path
		{ :controller => "lotto_bets", :action => :create }
	end
	def lotto_bet_path( ld )
		{ :controller => "lotto_bets", :action => :update, :id => @lb.id, :project_id => @project.identifier, :lotto_day_id => @lotto_day.id }
	end
end
