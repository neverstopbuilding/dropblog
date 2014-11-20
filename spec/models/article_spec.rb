require 'rails_helper'

RSpec.describe Article, type: :model do

  before(:each) do
    @article = create(:article)
  end

  it 'has a valid factory' do
    expect(@article).to be_valid
  end

  it 'is invalid without a title' do
    expect(build(:article, title: nil)).to_not be_valid
  end

  it 'is invalid without a slug' do
    expect(build(:article, slug: nil)).to_not be_valid
  end

  it 'is invalid without content' do
    expect(build(:article, content: nil)).to_not be_valid
  end

  it 'should validate that slugs are unique' do
    article_1 = build(:article, slug: 'unique-post')
    expect{ article_1.save }.to_not raise_error
    expect{ create(:article, slug: 'unique-post') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should return the slug as a param' do
    expect(@article.to_param).to eq @article.slug
  end

  it 'should render markdown content' do
    expect(build(:article, content: '# Title').render).to eq "<h1>Title</h1>\n"
  end

  it { should have_many(:pictures) }

  it 'should render an image short tag to an associated image path' do
    article = create(:article_picture).pictureable
    article.content = "![](../#{article.pictures[0].file_name})"
    article.save
    expect(article.render).to eq "<p><img src=\"#{article.pictures[0].path}\" alt=\"\"></p>\n"
  end

  it 'should not render an image if the image is not found' do
    article = create(:article_picture).pictureable
    article.content = "![](../wont-exist.jpg)"
    article.save
    expect(article.render).to eq ""
  end

end
