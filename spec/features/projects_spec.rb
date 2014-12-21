describe 'project requests', type: :request do

  it 'redirects a legacy project uri' do
    expect(get "/project/some-slug").to redirect_to('/some-slug')
  end

end


