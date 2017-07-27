module Api
  module Dropbox
    class ChangedFilesRetriever
      def initialize(client, dropbox_folder, redis)
        @client = client
        @dropbox_folder = '/'+ dropbox_folder
        @redis = redis
      end

      def fetch
        result_set = []
        has_more = true
        while has_more
          cursor = @redis.get 'dropbox_delta_cursor'
          if cursor
            result = @client.list_folder_continue(cursor)
          else
            result = @client.list_folder(@dropbox_folder, {recursive: true, include_deleted: true})
          end
          @redis.set('dropbox_delta_cursor', result.cursor)
          result_set += result.entries
          has_more = result.has_more?
        end
        return result_set
      end
    end
  end
end
