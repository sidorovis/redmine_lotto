class LottoDay < ActiveRecord::Base
	unloadable
	has_many :lotto_bets, :dependent => :delete_all
	has_one :lotto_day_result, :dependent => :delete

	validates_presence_of :description, :day
	validates_uniqueness_of :day

	def day_str
		day.strftime("%d/%m/%Y")
	end

end
