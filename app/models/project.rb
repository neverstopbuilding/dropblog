class Project < Document

  has_many :articles, -> { where type: 'Article' }, class_name: 'Article', foreign_key: 'document_id'

  def title_picture
    if pictures
      pictures.where('file_name ~* ?', '^title\.').first || pictures.first
    end
  end

  class << self

    def find_or_make_temp(slug)
      project = self.find_or_initialize_by(slug: slug)
      title = project.title || temp_title_from_slug(slug)
      project.title = title
      if project.valid?
        project.save
        project
      end
    end

    def process_project_from_file(slug, content)
      project = self.find_or_initialize_by(slug: slug)
      title = extract_title_from_content(content) || temp_title_from_slug(slug)
      content = strip_meta_from_content(content)
      project.title = title
      project.content = content
      if project.valid?
        project.save
        project
      end
    end

  end
end
