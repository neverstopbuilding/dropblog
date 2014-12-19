require 'rails_helper'

RSpec.describe Project, type: :model do

  it_behaves_like 'a documentable', Project, :project
  it_behaves_like 'a picturable', Project, :project_picture

  it { should have_many(:articles) }

end
