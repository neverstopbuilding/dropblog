feature 'Consulting page' do

  scenario 'redirect old links to consulting page to the prototyping page' do
    visit consulting_path
    expect(page).to have_content "Prototyping with a Craftsman's Spirit"
  end
end
