class Article < ActiveRecord::Base
  has_many :pictures, as: :pictureable
  belongs_to :project

  validates :title, :slug, :content, presence: true
  validates :slug, uniqueness: true

  def to_param
    slug
  end

    # TODO: Refactor this render out somewhere else
    class InsertImageRenderer < Redcarpet::Render::HTML

      def pictures=(pictures)
        @pictures = pictures
      end

      def image(link, title, alt_text)
        link = Pathname.new(link).basename.to_s
        picture = @pictures.find_by_file_name(link)
        if picture
          "<img src=\"#{picture.path}\" alt=\"#{alt_text}\">"
        else
          ""
        end
      end
    end

  def render

    renderer = InsertImageRenderer.new
    renderer.pictures = self.pictures

    markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)
    markdown.render content
  end
end
