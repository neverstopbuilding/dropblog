require 'dropbox_sdk'
class ProcessChangesJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # Do something later

    dropbox_blog_dir = ENV['dropbox_blog_dir']
    access_token = ENV['dropbox_access_token']

    client = DropboxClient.new(access_token)

    if Rails.env == 'development' || Rails.env == 'test'
      cursor = File.open('cursor.txt', 'rb') { |f| f.read }.strip.chomp
      delta = client.delta(cursor, "/#{dropbox_blog_dir}")
      File.open('cursor.txt', 'w+') { |f| f.write(delta['cursor']) }
    else
      cursor = REDIS.get 'dropbox_delta_cursor'
      delta = client.delta(cursor, "/#{dropbox_blog_dir}")
      REDIS.set 'dropbox_delta_cursor', delta['cursor']
    end

    if delta['entries'].empty?
      return []
    else
      delta['entries'].each do |entry|
        path = entry[0]
        if entry[0] =~ /\/#{dropbox_blog_dir}\/articles\/([a-z\-0-9]+)$/ && entry[1] == nil
          # remove article
          logger.info "Removing deleted article: #{$1}"
          to_delete = Article.find_by_slug($1)
          to_delete.destroy if to_delete
        end
        if entry[0] =~ /\/#{dropbox_blog_dir}\/projects\/public\/([a-z\-0-9]+)$/ && entry[1] == nil
          # remove article
          logger.info "Removing deleted project: #{$1}"
          to_delete = Project.find_by_slug($1)
          to_delete.destroy if to_delete
        end
        if entry[0] =~ /\/#{dropbox_blog_dir}\/projects\/public\/([a-z\-0-9]+)\/articles\/([a-z\-0-9]+).md$/ && entry[1] == nil
          # remove article from project
          logger.info "Removing deleted project article: #{$1} - #{$2}"
          to_delete = Article.find_by_slug($2)
          to_delete.destroy if to_delete
        end
        if entry[0] =~ /\/#{dropbox_blog_dir}\/articles\/([a-z\-0-9]+)\/article.md/ && entry[1] != nil
          logger.info "Processing updated or new article: #{$1}"
          contents, metadata = client.get_file_and_metadata(path)
          Article.process_raw_file($1, contents)
        end
        if entry[0] =~ /\/#{dropbox_blog_dir}\/projects\/public\/([a-z\-0-9]+)\/project.md/ && entry[1] != nil
          logger.info "Processing updated or new project: #{$1}"
          contents, metadata = client.get_file_and_metadata(path)
          Project.process_raw_file($1, contents)
        end
        if entry[0] =~ /\/#{dropbox_blog_dir}\/projects\/public\/([a-z\-0-9]+)\/articles\/([a-z\-0-9]+).md$/ && entry[1] != nil
          logger.info "Processing updated or new project article: #{$1} - #{$2}"
          contents, metadata = client.get_file_and_metadata(path)
          Project.process_raw_article_file($1, $2, contents)
        end
      end
    end


  end
end
