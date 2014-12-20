source 'https://rubygems.org'
ruby '2.1.5'
gem 'rails', '4.2.0.rc1'
gem 'sass-rails', '~> 4.0.3'
gem 'compass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development
gem 'figaro', '>= 1.0.0.rc1'
gem 'foundation-rails'
gem 'font-awesome-rails'
gem 'slim-rails'
gem 'redcarpet'
gem 'pg'
gem 'timers'
gem 'redis'
gem 'sidekiq'
gem 'dropbox-sdk'
gem 'responders'
gem 'rails_config'
gem 'aws-sdk'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_21]
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'guard-livereload', require: false
end
group :development, :test do
  gem 'spring-commands-rspec'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'vcr'
  gem 'webmock'
end
group :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'unicorn'
  gem 'unicorn-rails'
end
group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'codeclimate-test-reporter', require: nil
  gem 'shoulda-matchers', require: false

end
