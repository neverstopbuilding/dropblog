module Documentable
  extend ActiveSupport::Concern

  # included do
  #     has_many :comments, as: :commentable
  # end
  included do
    validates :title, :slug, presence: true
    validates :slug, uniqueness: true

    scope :recent, ->(how_many) { order(updated_at: :desc).limit(how_many) }
  end

  def updated_type
    updated_at == created_at ? 'Published on' : 'Last Updated on'
  end

  def to_param
    slug
  end

  def render
    renderer = Dropblog::Redcarpet::InsertImageRenderer.new
    renderer.pictures = self.pictures
    markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)
    markdown.render content
  end

  module ClassMethods
    def process_raw_file(slug, content)
      title_match = /^#\s?(.+)\n/.match(content)
      return nil unless title_match
      content.sub!(/^#\s?.+\n/, '').strip!
      title = title_match[1].titleize
      documentable = self.find_or_initialize_by(slug: slug)
      documentable.title = title
      documentable.content = content
      documentable.save
      documentable
    end
  end
end
