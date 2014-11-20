require 'rails_helper'

RSpec.describe Picture, :type => :model do

  it 'should have a valid factory' do
    expect(create(:article_picture)).to be_valid
  end

  it { should validate_presence_of(:file_name)}
end
