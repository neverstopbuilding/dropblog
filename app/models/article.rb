class Article < Document

  belongs_to :project, -> {where type: 'Project'}, class_name: 'Project', foreign_key: 'document_id', touch: true

  before_validation :check_slug

  def check_slug
    slug_match = /^(?:(\d{4}-\d{2}-\d{2})-)?([a-z\-0-9]+)$/.match(slug)
    if slug_match
      self.created_at = Time.parse(slug_match[1]) if slug_match[1]
      self.slug = slug_match[2]
    end
  end

  scope :of_interest, ->(interest) { joins('LEFT JOIN documents projects_documents ON projects_documents.id = documents.document_id').where('projects_documents.category = :category OR documents.category = :category', category: interest) }
  scope :next_by_date, lambda {|created_at| where("created_at > ?",created_at).order("created_at ASC") }
  scope :previous_by_date, lambda {|created_at| where("created_at < ?",created_at).order("created_at DESC") }

  def pictures
    #Override parent method to return correct picture set
    self.project ? self.project.pictures : super
  end

  def interest
    self.project && !category ? self.project.category : category
  end

  def previous
    self.class.previous_by_date(self.created_at).first
  end

  def next
    self.class.next_by_date(self.created_at).first
  end

  class << self

    def find_or_make_temp(slug)
      article = self.find_or_initialize_by(slug: slug)
      title = article.title || temp_title_from_slug(slug)
      article.title = title
      if article.valid?
        article.save
        article
      end
    end

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
