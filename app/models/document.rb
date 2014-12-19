class Document < ActiveRecord::Base
  include Documentable

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


end
