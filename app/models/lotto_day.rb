class LottoDay < ActiveRecord::Base
	unloadable

	validates_presence_of :description, :day, :project_id
	validates_uniqueness_of :day, :scope => :project_id

	has_many :lotto_bets, :dependent => :delete_all
	has_one :lotto_day_result, :dependent => :delete
	belongs_to :project

	def day_str
		day.strftime("%d/%m/%Y")
	end

	def day_result_description
		if finished
			if lotto_day_result
				"result: " + lotto_day_result.price.to_s
			else
				"no day result, no more bets."
			end
		else
			"day is free to bet"
		end		
	end
end
