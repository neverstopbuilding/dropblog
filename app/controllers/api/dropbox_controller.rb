module Api
  class DropboxController < ApplicationController
    skip_before_filter  :verify_authenticity_token
    respond_to :json

    def challenge
      code = params['challenge']
      logger.info "Dropbox webhook challenged with #{code}"
      render plain: code
    end

    def webhook
      begin
        validate_request_is_signed
        validate_signature
        ProcessChangesJob.perform_later
      rescue Exception => error
        logger.error "#{error.message}: #{error.inspect}"
      end
      render(json: 'Success')
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
