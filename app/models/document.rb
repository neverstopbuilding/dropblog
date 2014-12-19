class Document < ActiveRecord::Base

  has_many :pictures

  validates :title, :slug, presence: true
  validates :slug, uniqueness: true

  scope :recent, ->(how_many) { order(updated_at: :desc).limit(how_many) }

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

  class << self

    def destroy_by_slug(slug)
      to_delete = self.find_by_slug(slug)
      to_delete.destroy if to_delete
    end

    def extract_title_from_content(content)
      title_match = /^#\s?(.+)\n/.match(content)
      return nil unless title_match
      title_match[1].titleize
    end

    def strip_meta_from_content(content)
      content.sub(/^#\s?.+\n/, '').strip unless content.empty?
    end
  end
end
