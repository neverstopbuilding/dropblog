require 'rails_helper'

RSpec.describe Document, :type => :model do
  it 'has a valid factory' do
    expect(create(:document)).to be_valid
  end
end
