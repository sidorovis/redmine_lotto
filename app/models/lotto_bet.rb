class LottoBet < ActiveRecord::Base
	unloadable

	validates_presence_of :lotto_day_id, :user_id, :price, :project_id
	validates_numericality_of :price

	belongs_to :lotto_day
	belongs_to :user
	belongs_to :project

end
