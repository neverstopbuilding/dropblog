module Api
  module Dropbox
    module Errors
      class UnsignedRequestError < Error
        def status
          400
        end
        def message
          'Missing X-Dropbox-Signature'
        end
      end
    end
  end
end

