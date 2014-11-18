require 'rails_helper'

RSpec.describe Article, type: :model do
  it 'has a valid factory' do
    article = create(:article)
    expect(article).to be_valid
  end
end
