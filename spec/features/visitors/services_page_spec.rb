feature 'Services page' do

  scenario 'basic content' do
    visit services_path
    expect(page).to have_content 'Hardware with an Attention to Detail'
  end
end
