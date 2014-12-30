require 'rails_helper'

RSpec.describe Project, type: :model do

  it_behaves_like 'a documentable', Project, :project

  it { should have_many(:articles) }

  it 'can have a picture' do
    project = create(:project_with_picture)
    expect(project.pictures).to_not be_empty
  end

  it 'will create a default title based on slug if created without content' do
    content = ''
    slug = 'some-project-slug'
    project = Project.process_project_from_file(slug, content)
    expect(project.title).to eq 'Some Project Slug'
  end

  it 'can be created with raw content and a slug' do
    slug = 'some-slug'
    contents = '# this title
    some other stuff
    ## some section'
    project = Project.process_project_from_file(slug, contents)
    expect(project.title).to eq 'This Title'
    expect(project.content).to eq "some other stuff\n    ## some section"
    expect(Project.find_by_slug(slug)).to eq project
  end

  it 'can process raw contents to update an existing article' do
    project = create(:project)
    contents = '# this title
    some other stuff
    ## some section'
    Project.process_project_from_file(project.slug, contents)
    updated_project = Project.find_by_slug(project.slug)
    expect(updated_project.title).to eq 'This Title'
  end

  # TODO: these might be pulled out as they are rather similar with just different factories

  it 'should render an image short tag to an associated image path' do
    project = create(:project_with_picture)
    expect(project.render).to include "<p><div class=\"picture\"><img src=\"#{project.pictures[0].public_path}\" alt=\"\" title=\"\" /></div></p>\n"
  end

  it 'should not render an image if the image is not found' do
    project = create(:project_with_picture)
    project.content = "![](../wont-exist.jpg)"
    project.save
    expect(project.render).to eq ''
  end

end
