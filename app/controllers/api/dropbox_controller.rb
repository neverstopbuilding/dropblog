module Api
  class DropboxController < ApplicationController
    def challenge
      code = params['challenge']
      logger.info "Dropbox webhook challenged with #{code}"
      render plain: code
    end
  end
end
