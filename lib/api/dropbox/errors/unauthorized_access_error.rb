module Api
  module Dropbox
    module Errors
      class UnauthorizedAccessError < Error
        def status
          403
        end
        def message
          'Unauthorized'
        end
      end
    end
  end
end
