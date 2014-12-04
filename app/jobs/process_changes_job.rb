require 'dropbox_sdk'
class ProcessChangesJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # Do something later

    dropbox_blog_dir = ENV['dropbox_blog_dir']
    access_token = ENV['dropbox_access_token']

    client = DropboxClient.new(access_token)
    # puts "linked account:", client.account_info().inspect

    # cursor = File.read('experimental/cursor.txt')

    # cursor = cursor.empty? ? nil : cursor
    # TODO: you could put a time since last request checker or something

    # path_prefix = REDIS.get 'path_prefix'
    # if path_prefix != dropbox_blog_dir
    #   logger.info "Current prefix of '#{path_prefix}' does not match configured value of '#{dropbox_blog_dir}' updating..."
    #   path_prefix = dropbox_blog_dir
    #   REDIS.set 'path_prefix', path_prefix
    #   cursor = nil
    # else
    #   cursor = REDIS.get 'dropbox_delta_cursor'
    # end

    cursor = REDIS.get 'dropbox_delta_cursor'
    delta = client.delta(cursor, "/#{dropbox_blog_dir}")
    REDIS.set 'dropbox_delta_cursor', delta['cursor']

    if delta['entries'].empty?
      return []
    else
      delta['entries'].each do |entry|
        path = entry[0]
        if entry[0] =~ /\/dropblog-test\/articles\/([a-z\-0-9]+)$/ && entry[1] == nil
          # remove article
          logger.info "Removing deleted article: #{$1}"
          to_delete = Article.find_by_slug($1)
          to_delete.destroy if to_delete
        end
        if entry[0] =~ /\/#{dropbox_blog_dir}\/articles\/(.+)\/article.md/ && entry[1] != nil
          logger.info "Processing updated or new article: #{$1}"
          contents, metadata = client.get_file_and_metadata(path)
          Article.process_raw_file($1, contents)
        end
      end
    end
  end
end
