require 'rails_helper'
# require 'shared_examples/shared_examples_for_documentables'

RSpec.describe Article, type: :model do

  it_behaves_like 'a documentable', Article, :article

  it 'is invalid without content' do
    expect(build(:article, content: nil)).to_not be_valid
  end



  it 'will set the created date if the slug includes a date' do
    article_1 = build(:article, slug: '1985-06-08-unique-post')
    article_1.save
    expect(article_1.slug).to eq 'unique-post'
    expect(article_1.created_at).to eq '1985-06-08 04:00:00.000000000 +0000'
  end

  it 'can have a picture' do
    article = create(:article_with_picture)
    expect(article.pictures).to_not be_empty
  end

  it 'should render a project level image for a project article' do
    project = create(:project_with_picture_article)
    expect(project.articles[0].render).to include "<p><img src=\"#{project.pictures[0].public_path}\" alt=\"\" title=\"\"></p>\n"
  end

  it 'can be created with raw content and a slug' do
    slug = 'some-slug'
    contents = '# this title
    some other stuff
    ## some section'
    article = Article.process_article_from_file(slug, contents)
    expect(article.title).to eq 'This Title'
    expect(article.content).to eq "some other stuff\n    ## some section"
    expect(Article.find_by_slug(slug)).to eq article
  end

  it 'can process raw contents to update an existing article' do
    article = create(:article)
    contents = '# this title
    some other stuff
    ## some section'
    Article.process_article_from_file(article.slug, contents)
    updated_article = Article.find_by_slug(article.slug)
    expect(updated_article.title).to eq 'This Title'
  end

  it 'will simply not create a blank article' do
    slug = 'some-slug'
    contents = ''
    expect(Article.process_article_from_file(slug, contents)).to be_nil
  end

  it 'will simply not create a blank article' do
    slug = 'some-slug'
    contents = '# asdfasdf'
    expect(Article.process_article_from_file(slug, contents)).to be_nil
  end

  # TODO: these might be pulled out as they are rather similar with just different factories

  it 'should render an image short tag to an associated image path' do
    article = create(:article_with_picture)
    expect(article.render).to include "<p><img src=\"#{article.pictures[0].public_path}\" alt=\"\" title=\"\"></p>\n"
  end

  it 'should not render an image if the image is not found' do
    article = create(:article_with_picture)
    article.content = "![](../wont-exist.jpg)"
    article.save
    expect(article.render).to eq ''
  end

end
