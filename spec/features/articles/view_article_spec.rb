# Feature: Home page
#   As a visitor
#   I want to visit a home page
#   So I can learn more about the website
feature 'View Article' do

  scenario 'article created with out category' do
    article = create(:article)
    visit short_article_path(article)
    expect(page).to have_content article.title
  end
  # scenario 'default menu items' do
  #   visit root_path
  #   expect(page).to have_content 'Projects'
  #   expect(page).to have_content 'Articles'
  # end

  # scenario '5 most recently created articles' do
  #   titles = []
  #   6.times do
  #     article = create(:article)
  #     titles << article.title
  #   end
  #   visit root_path
  #   titles.last(5).each do |title|
  #     expect(page).to have_content title
  #   end
  #   expect(page).to_not have_content titles.first
  # end

  # scenario '5 most recently updated articles' do
  #   articles = []
  #   6.times do
  #     article = create(:article)
  #     articles << article
  #   end
  #   articles.first.title = 'Changed Title'
  #   articles.first.save
  #   visit root_path
  #   expect(page).to have_content 'Changed Title'
  # end

  # scenario '5 most recently updated projects' do
  #   projects = []
  #   7.times do
  #     project = create(:project_with_articles)
  #     projects << project
  #   end
  #   projects.first.title = 'New Project Title'
  #   projects.first.save

  #   article = projects[1].articles.first
  #   article.title = 'Updated Title'
  #   article.save
  #   visit root_path
  #   expect(page).to have_content 'New Project Title'
  #   expect(page).to have_content projects.second.title
  # end
end
