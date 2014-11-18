module Api
  class DropboxController < ApplicationController
    respond_to :json

    def challenge
      code = params['challenge']
      logger.info "Dropbox webhook challenged with #{code}"
      render plain: code
    end

    def webhook

      secret = ENV['dropbox_app_secret']

      data = request.body.read

      digest = OpenSSL::Digest::SHA256.new
      signature = OpenSSL::HMAC.hexdigest(digest, secret, data)

      unless request.headers['X-Dropbox-Signature']
        render(json: 'Missing X-Dropbox-Signature', status: 400)
        return
      end
      unless request.headers['X-Dropbox-Signature'] == signature
        render(json: 'Unauthorized', status: 403)
        return
      end
      render(json: 'Success', status: 200)

    end
  end
end
