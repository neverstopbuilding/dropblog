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

  it 'will process a new picture for an article' do
    article = create(:article)
    picture_attributes = attributes_for(:picture)
    expect(article.pictures).to be_empty

    picture = Picture.process_picture(picture_attributes[:file_name], picture_attributes[:public_path], article)

    expect(picture.document).to eq article
    expect(article.pictures).to_not be_empty
  end

  it 'will update an existing picture for an article' do
    picture = create(:article_picture)
    article = picture.document
    updated_picture = Picture.process_picture(picture.file_name, 'new path', article)
    expect(updated_picture.public_path).to eq 'new path'
  end

  it 'will process a new picture for a project' do
    project = create(:project)
    picture_attributes = attributes_for(:picture)
    expect(project.pictures).to be_empty

    picture = Picture.process_picture(picture_attributes[:file_name], picture_attributes[:public_path], project)

    expect(picture.document).to eq project
    expect(project.pictures).to_not be_empty
  end

  it 'will destroy a picture by file name' do
    picture = create(:article_picture)
    Picture.destroy_by_file_name(picture.file_name)
    expect(Picture.find_by_file_name(picture.file_name)).to be_nil
  end
end
