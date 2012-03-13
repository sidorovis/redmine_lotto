require 'redmine'

Redmine::Plugin.register :redmine_lottos do
  name 'Redmine Lottos plugin'
  author 'Ivan Sidarau'
  description 'This is a plugin for Redmine, for creating one day lottos. '
  version '0.0.1'
  url 'http://no-url.yet'
  author_url 'http://sidorovis.blogspot.com'
  menu :top_menu, :lottos, { :controller => 'lotto_days', :action => 'index' }, :caption => 'Lottos', :if => Proc.new { User.current.logged? }

  permission :view_lotto_days, :lotto_days => [:index, :show]
  permission :administrate_lotto_days, :lotto_days => [:new, :create, :edit, :destroy]
  permission :add_day_result, :lotto_day_results => [:new, :create]

end
