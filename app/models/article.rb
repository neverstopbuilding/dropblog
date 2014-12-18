class Article < ActiveRecord::Base
  has_many :pictures, as: :pictureable
  belongs_to :project, touch: true

  validates :title, :slug, :content, presence: true
  validates :slug, uniqueness: true

  scope :recent, -> { order(updated_at: :desc).limit(5) }

  def to_param
    slug
  end

  def updated_type
    updated_at == created_at ? 'Published on' : 'Last Updated on'
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

  def self.process_raw_file(slug, content)
    title_match = /^#\s?(.+)\n/.match(content)
    return nil unless title_match
    content.sub!(/^#\s?.+\n/, '').strip!
    title = title_match[1].titleize
    article = self.find_or_initialize_by(slug: slug)
    article.title = title
    article.content = content
    article.save
    article
  end
end
