require 'dropbox_sdk'
require 'open-uri'

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
          Article.destroy_by_slug($1)
        end
        if entry[0] =~ /\/#{dropbox_blog_dir}\/projects\/public\/([a-z\-0-9]+)$/ && entry[1] == nil
          # remove article
          logger.info "Removing deleted project: #{$1}"
          Project.destroy_by_slug($1)
        end
        if entry[0] =~ /\/#{dropbox_blog_dir}\/projects\/public\/([a-z\-0-9]+)\/articles\/([a-z\-0-9]+)\.md$/ && entry[1] == nil
          # remove article from project
          logger.info "Removing deleted project article: #{$1} - #{$2}"
          Article.destroy_by_slug($2)
        end
        if entry[0] =~ /\/#{dropbox_blog_dir}\/articles\/([a-z\-0-9]+)\/article\.md/ && entry[1] != nil
          # update article
          logger.info "Processing updated or new article: #{$1}"
          contents, metadata = client.get_file_and_metadata(path)
          Article.process_article_from_file($1, contents)
        end
        if entry[0] =~ /\/#{dropbox_blog_dir}\/projects\/public\/([a-z\-0-9]+)\/project\.md/ && entry[1] != nil
          # update project
          logger.info "Processing updated or new project: #{$1}"
          contents, metadata = client.get_file_and_metadata(path)
          Project.process_project_from_file($1, contents)
        end
        if entry[0] =~ /\/#{dropbox_blog_dir}\/projects\/public\/([a-z\-0-9]+)\/articles\/([a-z\-0-9]+)\.md$/ && entry[1] != nil
          # update project article
          logger.info "Processing updated or new project article: #{$1} - #{$2}"
          contents, metadata = client.get_file_and_metadata(path)
          project = Project.find_or_make_temp($1)
          Article.process_project_article_from_file($2, contents, project)
        end

        if entry[0] =~ /\/#{dropbox_blog_dir}\/articles\/([a-z\-0-9]+)\/.+\.(?:jpg|png|gif|jpeg|svg)$/ && entry[1] != nil
          # update article image
          path = entry[0]
          article_slug = $1
          logger.info "Processing updated or new image for: #{article_slug}"
          file_name = Pathname.new(path).basename.to_s
          key = "pictures/#{article_slug}/#{file_name}"

          # get data
          data, metadata = client.get_file_and_metadata(path)

          # select bucket
          bucket = S3.buckets[ENV['S3_BUCKET']]

          # upload data
          uploaded = bucket.objects[key].write(data)

          # update file
          article = Article.find_by_slug(article_slug)
          article.pictures.create(file_name: file_name, public_path: uploaded.public_url.to_s)

        end




      end
    end


  end
end
