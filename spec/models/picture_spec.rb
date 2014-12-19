require 'rails_helper'

RSpec.describe Picture, :type => :model do
  it 'has a valid factory' do
    expect(create(:picture)).to be_valid
  end

  it 'is invalid without a public_path' do
    expect(build(:picture, public_path: nil)).to_not be_valid
  end

  it 'is invalid without a file_name' do
    expect(build(:picture, file_name: nil)).to_not be_valid
  end

  it { should belong_to(:document) }

  it 'must be associated with a document' do
    expect(build(:picture, document: nil)).to_not be_valid
  end

  it 'can be associated with an article' do
    expect(build(:article_picture).document).to be_an_instance_of Article
  end

  it 'can be associated with a project' do
    expect(build(:project_picture).document).to be_an_instance_of Project
  end
end
