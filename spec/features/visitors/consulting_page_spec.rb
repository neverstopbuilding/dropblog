feature 'Consulting page' do

  scenario 'basic content' do
    visit consulting_path
    expect(page).to have_content 'Software with a Craftsman\'s Spirit'
  end
end
