require 'rails_helper'

RSpec.describe Project, type: :model do

  it_behaves_like 'a documentable', Project, :project

  it { should have_many(:articles) }

  it 'can have a picture' do
    project = create(:project_with_picture)
    expect(project.pictures).to_not be_empty
  end

  # TODO: these might be pulled out as they are rather similar with just different factories

  it 'should render an image short tag to an associated image path' do
    project = create(:project_with_picture)
    expect(project.render).to include "<p><img src=\"#{project.pictures[0].public_path}\" alt=\"\" title=\"\"></p>\n"
  end

  it 'should not render an image if the image is not found' do
    project = create(:project_with_picture)
    project.content = "![](../wont-exist.jpg)"
    project.save
    expect(project.render).to eq ''
  end

end
