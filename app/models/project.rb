class Project < ActiveRecord::Base

  include Documentable
  include Picturable

  has_many :articles

  def self.process_raw_article_file(project_slug, article_slug, content)
    project = self.find_or_initialize_by(slug: project_slug)
    project.title = project_slug.gsub!(/-/, ' ').titleize unless project.title
    project.articles << Article.process_raw_file(article_slug, content)
    project.save
    project
  end
end
