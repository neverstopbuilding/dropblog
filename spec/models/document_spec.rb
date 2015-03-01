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

  it 'will parse the meta data correctly' do
    document = Document.create(title: '2015-02-28 Fixing a Toshiba External Hard Drive (electronics)')
    expect(document.created_at).to eq Time.parse('2015-02-28')
    expect(document.category).to eq 'electronics'
    expect(document.title).to eq 'Fixing A Toshiba External Hard Drive'
  end

  it 'should raise an argument error on bad date parsing' do

    expect(Rails.logger).to receive(:error).with("The date provided: '2015-28-02' is likely not in the correct format: YYYY-MM-DD")
    expect do
      document = Document.create(title: '2015-28-02 Fixing a Toshiba External Hard Drive (electronics)')
    end.to raise_error ArgumentError
  end
end
