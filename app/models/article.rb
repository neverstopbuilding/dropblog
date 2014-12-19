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
end

