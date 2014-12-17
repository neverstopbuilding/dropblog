require 'rails_helper'

RSpec.describe ProcessChangesJob, :type => :job do

  it 'should show no changes' do
    VCR.use_cassette 'delta-test-no-changes' do
      expect(ProcessChangesJob.new.perform).to be_empty
    end
  end

  it 'update title of existing article' do
    VCR.use_cassette 'delta-test-update-article' do
      ProcessChangesJob.new.perform
      expect(Article.find_by_slug('one-off-article-slug').title).to eq 'Updated Title'
    end
  end

  it 'adds a new one off article' do
    VCR.use_cassette 'delta-test-new-article' do
      ProcessChangesJob.new.perform
      expect(Article.find_by_slug('new-article-slug').title).to eq 'The Title Of The Article'
    end
  end

  it 'will remove a slug change article and create a new one on slug change' do
    Article.create(title: 'Some title', slug: 'changed-article-slug', content: 'asdf')
    VCR.use_cassette('slug-change') do
      ProcessChangesJob.new.perform
      expect(Article.find_by_slug('changed-article-slug')).to be_nil
      expect(Article.find_by_slug('updated-article-slug').title).to eq 'Updated Title'
    end
  end

  it 'will simply remove an article outright' do
    Article.create(title: 'To Delete', slug: 'existing-article-to-delete', content: 'asdf')
    VCR.use_cassette('article-removal') do
      ProcessChangesJob.new.perform
      expect(Article.find_by_slug('existing-article-to-delete')).to be_nil
    end
  end

  it 'will create a project for a specific project page' do
    VCR.use_cassette 'create-new-project' do
      ProcessChangesJob.new.perform
      expect(Project.find_by_slug('simple-project').title).to eq 'Simple Project'
    end
  end

  it 'will create a intelligently titled temporary project if only an article for the project is created' do
    VCR.use_cassette 'create-temp-project-from-article' do
      ProcessChangesJob.new.perform
      project =  Project.find_by_slug('temp-project-slug')
      expect(project.title).to eq 'Temp Project Slug'
      expect(project.articles[0].title).to eq 'Project Started'
    end
  end

  it 'will revert to the real name of the article if an article file is created after' do
    Project.create(title: 'Temp Project Slug', slug: 'temp-project-slug', content: 'asdf')
    VCR.use_cassette 'update-project-title-after-article' do
      ProcessChangesJob.new.perform
      project =  Project.find_by_slug('temp-project-slug')
      expect(project.title).to eq 'Title In Project File'
      expect(project.articles[0].title).to eq 'Project Started Changed'
    end
  end
end
