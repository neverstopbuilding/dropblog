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
    it 'should reject request without signature' do
      data = { delta: { users: [12345678] }}.to_json
      post :webhook, data, format: :json
      expect(response.code).to eq '400'
      expect(response.body).to eq 'Missing X-Dropbox-Signature'
    end

    it 'should reject a request with a bad signature' do
      data = { delta: { users: [12345678] }}.to_json
      request.headers['X-Dropbox-Signature'] = sign_request(data, 'bad_app_secret')
      post :webhook, data, format: :json
      expect(response.code).to eq '403'
      expect(response.body).to eq 'Unauthorized'
    end

    it 'should accept a properly signed request' do
      data = { delta: { users: [12345678] }}.to_json
      request.headers['X-Dropbox-Signature'] = sign_request(data, ENV['dropbox_app_secret'])
      post :webhook, data, format: :json
      expect(response.code).to eq '200'
    end

    def sign_request(data, secret)
      digest = OpenSSL::Digest::SHA256.new
      OpenSSL::HMAC.hexdigest(digest, secret, data)
    end

  end
end
