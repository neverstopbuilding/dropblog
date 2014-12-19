class Article < Document



  belongs_to :project, -> {where type: 'Project'}, class_name: 'Project', foreign_key: 'document_id', touch: true

  validates :content, presence: true

  before_validation :check_slug

  def check_slug
    slug_match = /^(?:(\d{4}-\d{2}-\d{2})-)?([a-z\-0-9]+)$/.match(slug)
    if slug_match
      self.created_at = Time.parse(slug_match[1]) if slug_match[1]
      self.slug = slug_match[2]
    end
  end

  def pictures
    #Override parent method to return correct picture set
    self.project ? self.project.pictures : super
  end

  class << self


    def process_article_from_file(slug, content)
      article = self.find_or_initialize_by(slug: slug)
      title = extract_title_from_content(content)
      content = strip_meta_from_content(content)
      article.title = title
      article.content = content
      if article.valid?
        article.save
        article
      end
    end

    def process_project_article_from_file(slug, content, project)
      article = process_article_from_file(slug, content)
      if article
        project.articles << article
        project.save
        article
      end
    end
  end
end
