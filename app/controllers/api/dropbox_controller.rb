module Api
  class DropboxController < ApplicationController
    respond_to :json

    def challenge
      code = params['challenge']
      logger.info "Dropbox webhook challenged with #{code}"
      render plain: code
    end

    def webhook
      validate_request_is_signed
      validate_signature
      render(json: 'Success')
    rescue Api::Dropbox::Errors::Error => error
      render(json: error, status: error.status)
    end

    private

    def validate_request_is_signed
      fail Api::Dropbox::Errors::UnsignedRequestError unless request.headers['X-Dropbox-Signature']
    end

    def validate_signature
      calculated_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA256.new, ENV['dropbox_app_secret'], request.body.read)
      provided_signature = request.headers['X-Dropbox-Signature']
      fail Api::Dropbox::Errors::UnauthorizedAccessError unless provided_signature == calculated_signature
    end
  end
end
