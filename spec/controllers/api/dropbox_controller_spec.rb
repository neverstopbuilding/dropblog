require 'rails_helper'

RSpec.describe Api::DropboxController, type: :controller do

  describe 'GET dropbox' do
    it 'responds with challenge code' do
      challenge_code = Faker::Lorem.characters(10)
      get :challenge, challenge: challenge_code
      expect(response).to have_http_status(:success)
      expect(response.body).to eq challenge_code
    end
  end

  describe 'POST dropbox' do
    Sidekiq::Testing.fake!
    # it 'should reject request without signature' do
    #   post :webhook, sample_webhook_data, format: :json
    #   expect(response.code).to eq '400'
    #   expect(response.body).to eq 'Missing X-Dropbox-Signature'
    # end
    #
    # it 'should reject a request with a bad signature' do
    #   execute_signed_request 'bad_app_secret'
    #   expect(response.code).to eq '403'
    #   expect(response.body).to eq 'Unauthorized'
    # end

    it 'should accept a properly signed request' do
      execute_signed_request ENV['dropbox_app_secret']
      expect(response.code).to eq '200'
    end

    def sign_request(data, secret)
      digest = OpenSSL::Digest::SHA256.new
      OpenSSL::HMAC.hexdigest(digest, secret, data)
    end

    def sample_webhook_data
      { delta: { users: [12345678] } }.to_json
    end

    def execute_signed_request(secret)
      request.headers['X-Dropbox-Signature'] = sign_request(sample_webhook_data, secret)
      post :webhook, sample_webhook_data, format: :json
    end

  end
end
