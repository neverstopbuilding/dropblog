require 'rails_helper'
require 'dropbox_api'
require 'mock_redis'

RSpec.describe Api::Dropbox::ChangedFilesRetriever do

  before(:each) do
    @redis = MockRedis.new
    local_cursor = File.open('cursor.txt', 'rb') { |f| f.read }.strip.chomp
    @redis.set('dropbox_delta_cursor', local_cursor)

    dropbox_blog_dir = ENV['dropbox_blog_dir']
    access_token = ENV['dropbox_access_token']
    client = DropboxApi::Client.new(access_token)
    @retriever = Api::Dropbox::ChangedFilesRetriever.new(client, dropbox_blog_dir, @redis)
  end

  after(:each) do
    File.open('cursor.txt', 'w+') { |f| f.write(@redis.get('dropbox_delta_cursor')) }
  end

    it 'is intitialized with an API client, folder, and redis client' do
      expect(@retriever).to be_an_instance_of(Api::Dropbox::ChangedFilesRetriever)
    end

    it 'will get a cursor if there is none' do
      VCR.use_cassette('v2-get-cursor-with-none-stored') do
        @redis.del('dropbox_delta_cursor')
        entries = @retriever.fetch
        expect(entries).not_to be_empty
      end
    end

    it 'will list files recursivly' do
      VCR.use_cassette('v2-get-cursor-recursivly') do
        @redis.del('dropbox_delta_cursor')
        entries = @retriever.fetch
        expect(entries.count).not_to equal(2)
      end
    end

    it 'will return 0 entries if there are no changes' do
      VCR.use_cassette('v2-get-entries-no-changes') do
        entries = @retriever.fetch
        expect(entries.count).to equal(0)
      end
    end

      it 'will return deleted entries' do
        VCR.use_cassette('v2-get-deleted-entries') do
          entries = @retriever.fetch
          expect(entries.count).not_to equal(0)
        end
      end

      it 'will return an entry on a file addition' do
        VCR.use_cassette('v2-get-file-addition') do
          entries = @retriever.fetch
          expect(entries.count).to equal(2)
        end
      end
    end
