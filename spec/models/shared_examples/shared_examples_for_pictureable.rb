shared_examples 'a picturable' do |model, factory|
  it { should have_many(:pictures) }

  # This needs to be pulled out and split apart away from documentable or be part of a document

  it 'should render an image short tag to an associated image path' do
    documentable = create(factory).pictureable
    documentable.content = "![](../#{documentable.pictures[0].file_name})"
    documentable.save
    expect(documentable.render).to eq "<p><img src=\"#{documentable.pictures[0].path}\" alt=\"\" title=\"\"></p>\n"
  end

  it 'should not do a path replace for a normal link' do
    documentable = create(factory).pictureable
    documentable.content = "![some comment](http://cool.com/image.png)"
    documentable.save
    expect(documentable.render).to eq "<p><img src=\"http://cool.com/image.png\" alt=\"some comment\" title=\"\"></p>\n"
  end

  it 'should not render an image if the image is not found' do
    documentable = create(factory).pictureable
    documentable.content = "![](../wont-exist.jpg)"
    documentable.save
    expect(documentable.render).to eq ''
  end
end
