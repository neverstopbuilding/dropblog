shared_examples 'a picturable' do |model, factory|
  it { should have_many(:pictures) }
end
