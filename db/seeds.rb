# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html

# Create 4 projects with articles and 5 stand alone articles

FactoryGirl.create(:project_with_articles)
FactoryGirl.create(:article)
FactoryGirl.create(:project)
4.times { FactoryGirl.create(:project_with_articles) }
5.times { FactoryGirl.create(:article) }
