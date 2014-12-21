require 'rails_helper'

RSpec.describe Document, :type => :model do
  it 'has a valid factory' do
    expect(create(:document)).to be_valid
  end

  it 'will return a list of interests' do
    create(:document, category: 'ham')
    create(:document, category: 'jam')
    expect(Document.interests).to include 'ham'
    expect(Document.interests).to include 'jam'
    expect(Document.interests.length).to eq 2
  end
end
