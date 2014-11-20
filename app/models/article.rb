class Article < ActiveRecord::Base
  has_many :pictures, as: :imageable
  belongs_to :project

  validates :title, :slug, :content, presence: true
  validates :slug, uniqueness: true

  def to_param
    slug
  end

  def render
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render content
  end
end
