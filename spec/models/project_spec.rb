require 'rails_helper'

RSpec.describe Project, type: :model do

  before(:each) do
    @project = create(:project)
  end

  it 'has a valid factory' do
    expect(@project).to be_valid
  end

  it 'is invalid without a title' do
    expect(build(:project, title: nil)).to_not be_valid
  end

  it 'is invalid without a slug' do
    expect(build(:project, slug: nil)).to_not be_valid
  end

  it 'is invalid without content' do
    expect(build(:project, content: nil)).to_not be_valid
  end

  it 'should validate that slugs are unique' do
    project_1 = build(:project, slug: 'unique-post')
    expect { project_1.save }.to_not raise_error
    expect { create(:project, slug: 'unique-post') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should return the slug as a param' do
    expect(@project.to_param).to eq @project.slug
  end

  it 'should render markdown content' do
    expect(build(:project, content: '# Title').render).to eq "<h1>Title</h1>\n"
  end

  it { should have_many(:pictures) }

  it 'will report its updated status' do
    expect(@project.updated_type).to eq 'Published on'
    @project.title = 'Changed title'
    @project.save
    expect(@project.updated_type).to eq 'Last Updated on'
  end


  # Seemingly Project Specific

  it { should have_many(:articles) }

end
