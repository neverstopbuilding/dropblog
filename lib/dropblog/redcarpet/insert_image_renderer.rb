module Dropblog
  module Redcarpet
    class InsertImageRenderer < ::Redcarpet::Render::HTML

      def pictures=(pictures)
        @pictures = pictures
      end

      def image(link, title, alt_text)
        if link =~ /^\.\.?\/.+$/
          link = Pathname.new(link).basename.to_s
          picture = @pictures.find_by_file_name(link)
          if picture
            wrap_in_picture_div("<img src=\"#{picture.public_path}\" alt=\"#{alt_text}\" title=\"#{title}\">")
          else
            ""
          end
        else
          wrap_in_picture_div("<img src=\"#{link}\" alt=\"#{alt_text}\" title=\"#{title}\">")
        end
      end

      def wrap_in_picture_div(html)
        "<div class=\"picture\">#{html}</div>"
      end
    end
  end
end
