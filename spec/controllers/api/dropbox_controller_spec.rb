require 'rails_helper'

RSpec.describe Api::DropboxController, type: :controller do

  describe 'GET webhook' do
    it 'responds with challenge code' do
      challenge_code = Faker::Lorem.characters(10)
      get :challenge, challenge: challenge_code
      expect(response).to have_http_status(:success)
      expect(response.body).to eq challenge_code
    end
  end

end
