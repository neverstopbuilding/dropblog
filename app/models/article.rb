class Article < ActiveRecord::Base
  has_many :pictures, as: :imageable
  belongs_to :project

  def to_param
    slug
  end

  def render
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render content
  end
end
