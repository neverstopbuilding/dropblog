module Dropblog
  module Redcarpet
    class InsertImageRenderer < ::Redcarpet::Render::HTML

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
  end
end
