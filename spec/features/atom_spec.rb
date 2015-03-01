# require 'rails_helper'
#
# describe 'rss routing' do
#   it 'should redirect atom to the index' do
#     expect(get: 'atom.xml').to route_to(
#           controller: 'visitors',
#           action: 'index'
#         )
#   end
# end

describe 'atom requests', type: :request do

  it 'redirects atom request to home page' do
    host! 'example.com'
    expect(get "/atom.xml").to redirect_to('/')
  end

end
