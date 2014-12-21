class Document < ActiveRecord::Base

  has_many :pictures

  validates :title, :slug, presence: true
  validates :slug, uniqueness: true

  default_scope { order(updated_at: :desc) }
  scope :recent, ->(how_many) { order(updated_at: :desc).limit(how_many) }
  scope :of_interest, ->(interest) { where(category: interest) }

  before_validation :extract_meta_data_from_title

  alias_attribute :interest, :category

  def extract_meta_data_from_title
    meta_match = /^(?:(\d{4}-\d{2}-\d{2})\s)?(.+?)(?:\s\((\w+)\))?$/.match(title)
    if meta_match
      self.created_at = Time.parse(meta_match[1]) if meta_match[1]
      self.category = meta_match[3].downcase if meta_match[3]
      self.title = meta_match[2].titleize
    end
  end

  def updated_type
    updated_at == created_at ? 'Published on' : 'Last Updated on'
  end

  def been_updated?
    updated_at != created_at
  end

  def project_article?
    methods.include?(:project) && self.project
  end

  def to_param
    slug
  end

  def snippet(length = 150)
    require 'redcarpet/render_strip'
    renderer = Redcarpet::Render::StripDown.new
    markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)
    markdown.render(content)
  end

  def render
    renderer = Dropblog::Redcarpet::InsertImageRenderer.new
    renderer.pictures = self.pictures
    markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true, fenced_code_blocks: true)
    markdown.render content
  end

  class << self

    def interests
      Document.pluck(:category).uniq.compact
    end

    def destroy_by_slug(slug)
      to_delete = self.find_by_slug(slug)
      to_delete.destroy if to_delete
    end

    def extract_title_from_content(content)
      title_match = /^#\s?(.+)\n/.match(content)
      return nil unless title_match
      title_match[1].titleize
    end

    def temp_title_from_slug(slug)
      slug.gsub!(/-/, ' ').titleize
    end

    def strip_meta_from_content(content)
      content.sub(/^#\s?.+\n/, '').strip unless content.empty?
    end
  end
end
