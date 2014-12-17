# Feature: Home page
#   As a visitor
#   I want to visit a home page
#   So I can learn more about the website
feature 'Home page' do

  scenario 'default menu items' do
    visit root_path
    expect(page).to have_content 'Projects'
    expect(page).to have_content 'Articles'
  end

  scenario '5 most recently created articles' do
    titles = []
    6.times do
      article = create(:article)
      titles << article.title
    end

    visit root_path
    titles.last(5).each do |title|
      expect(page).to have_content title
    end

    expect(page).to_not have_content titles.first

  end

end
