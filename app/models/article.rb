class Article < ActiveRecord::Base

  include Documentable
  include Picturable

  belongs_to :project, touch: true

  validates :content, presence: true

  before_validation :check_slug

  def check_slug
    slug_match = /^(?:(\d{4}-\d{2}-\d{2})-)?([a-z\-0-9]+)$/.match(slug)
    if slug_match
      self.created_at = Time.parse(slug_match[1]) if slug_match[1]
      self.slug = slug_match[2]
    end
  end


end
