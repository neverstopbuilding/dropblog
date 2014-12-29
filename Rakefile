# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :sitemap do
 task :symlink do
    system("cp #{Rails.root}/public/sitemaps/sitemap.xml #{Rails.root}/public/sitemap.xml")
 end
end
