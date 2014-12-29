describe 'project requests', type: :request do

  it 'redirects a legacy project uri' do
    host! 'example.com'
    expect(get "/project/some-slug").to redirect_to('/some-slug')
  end

end


