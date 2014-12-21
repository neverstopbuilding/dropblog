require 'rails_helper'

describe 'interests routing' do

  it 'should route to the interests index' do
    expect(get: '/interests').to route_to(
          controller: 'interests',
          action: 'index'
        )
  end

  it 'should route to the interests index' do
    expect(get: '/interests/something').to route_to(
          controller: 'interests',
          action: 'show',
          interest: 'something'
        )
  end

end
