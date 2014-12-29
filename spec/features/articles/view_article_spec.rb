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
end
