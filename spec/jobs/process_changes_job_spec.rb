require 'rails_helper'

RSpec.describe ProcessChangesJob, :type => :job do

  it 'should try a basic job' do
    VCR.use_cassette 'delta-test' do
      ProcessChangesJob.new.perform
    end
  end

  it 'should show no changes' do
    VCR.use_cassette 'delta-test-no-changes' do
      ProcessChangesJob.new.perform
    end
  end

  it 'adds a new one off article' do
    VCR.use_cassette 'delta-test-new-article' do
      ProcessChangesJob.new.perform
      expect(Article.find_by_slug('one-off-article-slug').title).to eq 'The Title Of The Article'
    end
  end
end
