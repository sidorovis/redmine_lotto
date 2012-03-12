class LottoBet < ActiveRecord::Base
	unloadable
	belongs_to :lotto_day
	belongs_to :user
end
