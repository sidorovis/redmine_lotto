class LottoBet < ActiveRecord::Base
	unloadable
	belongs_to :lotto_day
	belongs_to :user

	validates_presence_of :lotto_day_id, :user_id, :price
end
