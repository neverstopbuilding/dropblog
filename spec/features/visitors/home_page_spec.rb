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

end
