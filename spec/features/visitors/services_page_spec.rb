feature 'Services page' do

  scenario 'basic content' do
    visit services_path
    expect(page).to have_content "Prototyping with a Craftsman's Spirit"
  end
end
