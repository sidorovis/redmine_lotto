class LottoDay < ActiveRecord::Base
	unloadable
	has_many :lotto_bets, :dependent => :delete_all
	has_one :lotto_day_result, :dependent => :delete
	def to_s
		day.strftime("%d/%m/%Y")
	end
end
