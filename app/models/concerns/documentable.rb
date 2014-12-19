module Documentable
  extend ActiveSupport::Concern

  module ClassMethods
    def process_raw_file(slug, content)
      title_match = /^#\s?(.+)\n/.match(content)
      return nil unless title_match
      content.sub!(/^#\s?.+\n/, '').strip!
      title = title_match[1].titleize
      documentable = self.find_or_initialize_by(slug: slug)
      documentable.title = title
      documentable.content = content
      documentable.save
      documentable
    end
  end
end
