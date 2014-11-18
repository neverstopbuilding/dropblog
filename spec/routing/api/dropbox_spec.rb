require 'rails_helper'

describe 'dropbox routing' do

  it 'should route the webhook challenge correctly' do
    expect(get: '/api/dropbox').to route_to(
          controller: 'api/dropbox',
          action: 'challenge'
        )
  end

  it 'should route the webhook post correctly' do
    expect(post: '/api/dropbox').to route_to(
        controller: 'api/dropbox',
        action: 'webhook'
      )
  end

end
