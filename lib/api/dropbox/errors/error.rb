module Api
  module Dropbox
    module Errors
      class Error < StandardError
        def to_json(*)
          message
        end
      end
    end
  end
end
