class Document < ActiveRecord::Base

  has_many :pictures

  validates :title, :slug, presence: true
  validates :slug, uniqueness: true

  scope :recent, ->(how_many) { order(created_at: :desc).limit(how_many) }
  scope :recently_updated, ->(how_many) { order(updated_at: :desc).limit(how_many) }
  scope :of_interest, ->(interest) { where(category: interest) }

  before_validation :extract_meta_data_from_title

  alias_attribute :interest, :category

  def extract_meta_data_from_title
    meta_match = /^(?:(\d{4}\-\d{2}\-\d{2})\s)?(.+?)(?:\s\((\w+)\))?$/.match(title)
    if meta_match
      self.created_at = parse_date(meta_match[1]) if meta_match[1]
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

  def month_created
    created_at.strftime("%B, %Y")
  end

  def month_updated
    updated_at.strftime("%B, %Y")
  end

  def snippet(length = 150)
    return '' unless content
    require 'redcarpet/render_strip'
    renderer = Redcarpet::Render::StripDown.new
    markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)
    markdown.render(content)
  end

  def render
    return '' unless content
      render_options = {
        line_numbers: true,
        inline_theme: 'github'
      }

    renderer = Dropblog::Redcarpet::InsertImageRenderer.new(render_options)
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
      title_match[1]
    end

    def temp_title_from_slug(slug)
      slug.gsub!(/-/, ' ')
    end

    def strip_meta_from_content(content)
      content.sub(/^#\s?.+\n/, '').strip unless content.empty?
    end
  end

  private

  def parse_date(date_string)
    Time.parse(date_string)
  rescue ArgumentError => e
    raise e unless e.message == 'argument out of range'
    message = "The date provided: '#{date_string}' is likely not in the correct format: YYYY-MM-DD"
    logger.error(message)
    raise ArgumentError, message
  end
end
