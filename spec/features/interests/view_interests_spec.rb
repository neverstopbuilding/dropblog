feature 'View Interests' do

  scenario 'browse to interests' do
    visit interests_path
    expect(page).to have_content 'Interests'
  end
end
