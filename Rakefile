# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :sitemap do
  require 'sitemap_generator'
  task :ping do
    SitemapGenerator::Sitemap.ping_search_engines('http://neverstopbuilding.com/sitemap.xml')
  end
end
