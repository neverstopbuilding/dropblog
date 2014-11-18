require 'rails_helper'

describe 'dropbox routing' do

  it 'should route the webhook challenge correctly' do
    expect(get: '/api/dropbox').to route_to(
          controller: 'api/dropbox',
          action: 'challenge'
        )
  end

  # it 'should route to the correct login page' do
  #   expect(get: "#{url}/sign_in").to route_to(
  #     controller: 'sessions',
  #     action: 'new'
  #   )
  # end

  # it 'should not route to a bad subdomain' do
  #   expect(get: "#{bad_url}/sign_in").to_not route_to(
  #     controller: 'sessions',
  #     action: 'new'
  #   )
  # end

  # it 'should not route to the login page from the non subdomain' do
  #   expect(get: '/sign_in').to_not route_to(
  #     controller: 'sessions',
  #     action: 'new'
  #   )
  # end

end
