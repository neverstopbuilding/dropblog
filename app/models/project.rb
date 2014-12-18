class Project < ActiveRecord::Base
  has_many :pictures, as: :pictureable
  has_many :articles

  validates :title, :slug, presence: true
  validates :slug, uniqueness: true

  scope :recent, -> { order(updated_at: :desc).limit(5) }

  def updated_type
    updated_at == created_at ? 'Published on' : 'Last Updated on'
  end

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

  # the project and article (which are really rather similar) should contain raw markdown,
  # this will have relative slug links to the images
  # durring parsing it will use the slugs to pull in the actual image path

  # articles and projects are basically the same thing
  # so we could say an article is documentable as is a project
  # projects only really have sub articles related to them
  # any content is imagable, categorizable, taggable, etc it has a title, slug, content
  # it can be uniformly rendered

  # could use single table inheretance with

  def self.process_raw_file(slug, content)
    title_match = /^#\s?(.+)\n/.match(content)
    return nil unless title_match
    content.sub!(/^#\s?.+\n/, '').strip!
    title = title_match[1].titleize
    project = self.find_or_initialize_by(slug: slug)
    project.title = title
    project.content = content
    project.save
    project
  end

  def self.process_raw_article_file(project_slug, article_slug, content)
    project = self.find_or_initialize_by(slug: project_slug)
    project.title = project_slug.gsub!(/-/, ' ').titleize unless project.title
    project.articles << Article.process_raw_file(article_slug, content)
    project.save
    project
  end
end
