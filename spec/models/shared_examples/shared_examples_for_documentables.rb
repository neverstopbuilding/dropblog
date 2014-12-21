shared_examples 'a documentable' do |model, factory|
  it { should have_many(:pictures) }

  it 'has a valid factory' do
    expect(create(factory)).to be_valid
  end

  it 'is invalid without a title' do
    expect(build(factory, title: nil)).to_not be_valid
  end

  it 'is invalid without a slug' do
    expect(build(factory, slug: nil)).to_not be_valid
  end

  it 'should validate that slugs are unique' do
    documentable_1 = build(factory, slug: 'unique-documentable')
    expect{ documentable_1.save }.to_not raise_error
    expect{ create(factory, slug: 'unique-documentable') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should return the slug as a param' do
    documentable = build(factory)
    expect(documentable.to_param).to eq documentable.slug
  end

  it 'should return an empty string for snippet with no content' do
    documentable = build(factory, content: nil)
    expect(documentable.snippet).to eq ''
  end

  it 'should render nothing for empty content' do
    documentable = build(factory, content: nil)
    expect(documentable.render).to eq ''
  end

  it 'should render markdown content' do
    expect(build(factory, content: '# Title').render).to eq "<h1>Title</h1>\n"
  end

  it 'will report its updated status' do
    documentable = create(factory)
    expect(documentable.updated_type).to eq 'Published on'
    documentable.title = 'Changed title'
    documentable.save
    expect(documentable.updated_type).to eq 'Last Updated on'
  end

  it 'can be destroyed by slug' do
    documentable = create(factory)
    model.destroy_by_slug(documentable.slug)
    expect(model.find_by_slug(documentable.slug)).to be_nil
  end

  it 'supports the recent scope' do
    older = build(factory, updated_at: 5.years.ago)
    older.save
    newer = create(factory)
    expect(model.recent(1)).to eq [newer]
    expect(model.recent(2)).to eq [newer, older]
  end

  it 'should not do a path replace for a normal link' do
    documentable = create(factory)
    documentable.content = "![some comment](http://cool.com/image.png)"
    documentable.save
    expect(documentable.render).to eq "<p><img src=\"http://cool.com/image.png\" alt=\"some comment\" title=\"\"></p>\n"
  end

  it 'should pull out a basic unix date from the title string' do
    documentable = create(factory, title: '2012-05-08 The real Title')
    expect(documentable.title).to eq 'The Real Title'
    expect(documentable.created_at).to eq Time.parse('2012-05-08')
  end

  it 'should pull out a category from the title string' do
    documentable = create(factory, title: 'The real Title (SoFtware)')
    expect(documentable.title).to eq 'The Real Title'
    expect(documentable.category).to eq 'software'
  end

  it 'should extract meta data from title' do
    documentable = create(factory, title: '2012-05-08 The real Title (SoFtware)')
    expect(documentable.title).to eq 'The Real Title'
    expect(documentable.category).to eq 'software'
    expect(documentable.created_at).to eq Time.parse('2012-05-08')
  end

  it 'should provide a title picture' do
    documentable = create(factory)
    picture = build(:picture, updated_at: 3.days.ago)
    documentable.pictures << picture
    documentable.pictures << build(:picture, updated_at: 5.days.ago)
    documentable.save
    expect(documentable.title_picture.public_path).to eq picture.public_path
  end

  it 'should choose a title picture with the file name "title" of all others' do
    documentable = create(factory)
    documentable.pictures << create(:picture)
    documentable.pictures << create(:picture, file_name: 'title.png')
    documentable.pictures << create(:picture, file_name: 'title-something.jpg')
    documentable.save
    expect(documentable.title_picture.file_name).to eq 'title.png'
  end

end
