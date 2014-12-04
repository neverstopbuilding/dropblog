require 'dropbox_sdk'
class ProcessChangesJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # Do something later



    access_token = ENV['dropbox_access_token']

    client = DropboxClient.new(access_token)
    # puts "linked account:", client.account_info().inspect

    # cursor = File.read('experimental/cursor.txt')

    # cursor = cursor.empty? ? nil : cursor
    # TODO: you could put a time since last request checker or something

    cursor = REDIS.get 'dropbox_delta_cursor'
    delta = client.delta(cursor, '/dropblog-test')
    REDIS.set 'dropbox_delta_cursor', delta['cursor']

    if delta['entries'].empty?
      puts 'nothing changed'
    else
      delta['entries'].each do |entry|
        path = entry[0]
        if entry[0] =~ /\/dropblog-test\/articles\/(.+)\/article.md/
          logger.info "Processing updated or new article: #{$1}"
          contents, metadata = client.get_file_and_metadata(path)
          Article.process_raw_file($1, contents)
        end
      end
    end
  end
end
