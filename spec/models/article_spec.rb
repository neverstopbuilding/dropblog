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

  it 'can process raw contents to create a new article' do
    slug = 'some-slug'
    contents = '# this title
    some other stuff
    ## some section'
    article = Article.process_raw_file(slug, contents)
    expect(article.title).to eq 'This Title'
    expect(article.content).to eq "some other stuff\n    ## some section"
    expect(Article.find_by_slug('some-slug')).to eq article
  end

  it 'can process raw contents to update an existing article' do
    contents = '# this title
    some other stuff
    ## some section'
    article = Article.process_raw_file(@article.slug, contents)
    updated_article = Article.find_by_slug(@article.slug)
    expect(updated_article.title).to eq 'This Title'
  end

  it 'will simply not create a blank article' do
    slug = 'some-slug'
    contents = ''
    expect(Article.process_raw_file(slug, contents)).to be_nil
  end

  it 'will simply not create a blank article' do
    slug = 'some-slug'
    contents = '# asdfasdf'
    expect(Article.process_raw_file(slug, contents)).to be_nil
  end

  it 'will report its updated status' do
    expect(@article.updated_type).to eq 'Published on'
    @article.title = 'Changed title'
    @article.save
    expect(@article.updated_type).to eq 'Last Updated on'
  end

  it 'will set the created date if the slug includes a date' do
    article_1 = build(:article, slug: '1985-06-08-unique-post')
    article_1.save
    expect(article_1.slug).to eq 'unique-post'
    expect(article_1.created_at).to eq '1985-06-08 04:00:00.000000000 +0000'
  end

end
