class LottoDayResult < ActiveRecord::Base
	unloadable
	belongs_to :lotto_day
	belongs_to :user, :class_name => "User", :foreign_key => :winner
end
