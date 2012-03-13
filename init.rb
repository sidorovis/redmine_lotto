require 'redmine'

Redmine::Plugin.register :redmine_lottos do
	name 'Redmine Lottos plugin'
	author 'Ivan Sidarau'
	description 'This is a plugin for Redmine, for creating one day lottos. '
	version '0.0.1'
	url 'http://no-url.yet'
	author_url 'http://sidorovis.blogspot.com'

#  menu :project_menu, :lottos, { :controller => 'lotto_days', :action => 'index' }, :caption => 'Lottos', :if => Proc.new { User.current.logged? }, :param => :project_id

	project_module :lottos do

		menu :project_menu, :lottos, { :controller => 'lotto_days', :action => 'index' }, :caption => 'Lottos', :param => :project_id

#		menu :project_menu, :lottos, { :controller => "" } , :caption => 'Lottos'
#, :param => :project_id

		permission :view_lotto_days, :lotto_days => [:index, :show]
		permission :administrate_lotto_days, :lotto_days => [:new, :create, :edit, :update, :destroy]

		permission :add_day_results, :lotto_day_results => [:new, :create]
		permission :administrate_day_results, :lotto_day_results => [:new, :create, :edit, :update, :destroy]

#		permission :administrate_own_bet, :lotto_bet => [:new, :create, :edit, :update]

	end
end
