class LottoLog < ActiveRecord::Base
	unloadable

	validates_presence_of :project_id, :user_id, :project_id, :title, :description
	belongs_to :user
	belongs_to :project

	def LottoLog.log( project_id, user_id, title, description )
		ll = LottoLog.new
		ll.project_id = project_id
		ll.user_id = user_id
		ll.title = title
		ll.description = description
		return ll.save
	end

end
