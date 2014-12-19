require 'rails_helper'
# require 'shared_examples/shared_examples_for_documentables'

RSpec.describe Article, type: :model do

  it_behaves_like 'a documentable', Article, :article
  # it_behaves_like 'a picturable', Article, :article_picture

  it 'is invalid without content' do
    expect(build(:article, content: nil)).to_not be_valid
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

  it 'will set the created date if the slug includes a date' do
    article_1 = build(:article, slug: '1985-06-08-unique-post')
    article_1.save
    expect(article_1.slug).to eq 'unique-post'
    expect(article_1.created_at).to eq '1985-06-08 04:00:00.000000000 +0000'
  end

end
