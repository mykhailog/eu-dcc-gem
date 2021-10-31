module EuDcc
  module TrustListRepository
    class Test
      def initialize(data)
        if data.is_a?(Hash)
          if data["CERTIFICATE"]
            @data = { "rawData" => data["CERTIFICATE"] }
          end
        elsif data.is_a?(String)
          @data = { "rawData" => data }
        end
      end

      def find_by_kid(kid)
        @data
      end
    end
  end
end
