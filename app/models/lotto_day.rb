class LottoDay < ActiveRecord::Base
	unloadable

	validates_presence_of :description, :day, :project_id
	validates_uniqueness_of :day

	has_many :lotto_bets, :dependent => :delete_all
	has_one :lotto_day_result, :dependent => :delete
	belongs_to :project

	def day_str
		day.strftime("%d/%m/%Y")
	end

end
