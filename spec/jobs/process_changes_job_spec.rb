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
      project = Project.find_by_slug('simple-project')
      expect(project.title).to eq 'Simple Project'
      expect(project.render).to eq "<p>some text</p>\n\n<h2>Some Heading</h2>\n"
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

  it 'will remove a project article if the slug changes and create a new one' do
    article = Article.create(title: 'Change Slug', slug: 'slug-before-change', content: 'asdf')
    project = Project.create(title: 'Change Article Slug Project', slug: 'project-for-article-slug-change', content: 'asdf')
    project.articles << article
    project.save

    VCR.use_cassette('project-article-slug-change') do
      ProcessChangesJob.new.perform
      expect(Article.find_by_slug('slug-before-change')).to be_nil
      project =  Project.find_by_slug('project-for-article-slug-change')
      expect(project.articles[0].slug).to eq 'slug-after-change'
    end
  end

  it 'will remove a project and update the associated articles on project slug change' do
    project = Project.new(title: 'Change Project Slug', slug: 'project-slug-before-change', content: 'asdf')
    project.articles << Article.create(title: 'Article 1', slug: 'article-1', content: 'asdf')
    project.articles << Article.create(title: 'Article 2', slug: 'article-2', content: 'asdf')
    project.save

    VCR.use_cassette('project-slug-change') do
      ProcessChangesJob.new.perform
      expect(Project.find_by_slug('project-slug-before-change')).to be_nil
      project = Project.find_by_slug('project-slug-after-change')
      expect(project.articles[0].title).to eq 'Article 2'
      expect(project.articles[1].title).to eq 'Article 1'
    end
  end

  it 'will update an picture record for an article' do
    article = Article.create(title: 'Picture Article', slug: 'picture-article', content: 'asdf')
    VCR.use_cassette('add-picture-to-article') do
      ProcessChangesJob.new.perform
      expect(article.pictures[0].file_name).to eq 'jason-fox-small.jpg'
      expect(article.pictures[0].public_path).to_not be_empty
    end
  end

  it 'will create a temp article on adding a picture first' do
    article_slug = 'picture-first-slug'
    VCR.use_cassette('create-temp-article-from-picture') do
      ProcessChangesJob.new.perform
      article = Article.find_by_slug(article_slug)
      expect(article.title).to eq 'Picture First Slug'
      expect(article.pictures[0].file_name).to eq 'jason-fox-small.jpg'
      expect(article.pictures[0].public_path).to_not be_empty
    end
  end

  it 'will remove a picture when removed' do
    article = Article.create(title: 'Picture Article', slug: 'picture-article', content: 'asdf')
    article.pictures.create(file_name: 'jason-fox-small.jpg', public_path: 'some path')
    VCR.use_cassette('remove-picture-from-article') do
      ProcessChangesJob.new.perform
      updated_article = Article.find_by_slug('picture-article')
      expect(updated_article.pictures).to be_empty
    end
  end

  it 'will update an picture record for a project' do
    project = Project.create(title: 'Picture Article', slug: 'simple-project', content: 'asdf')
    VCR.use_cassette('add-picture-to-project') do
      ProcessChangesJob.new.perform
      expect(project.pictures[0].file_name).to eq 'jason-fox-small.jpg'
      expect(project.pictures[0].public_path).to_not be_empty
    end
  end

end
