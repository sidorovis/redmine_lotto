class LottoDayResult < ActiveRecord::Base
	unloadable
	validates_presence_of :lotto_day_id, :price, :project_id

	validates_uniqueness_of :lotto_day_id
	validates_numericality_of :price

	belongs_to :lotto_day
	belongs_to :project

end
