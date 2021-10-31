# frozen_string_literal: true
module EuDcc
  module TrustListRepository
    class Local
      def initialize(data)
        if data.is_a? String
          data = JSON.parse(data)
        elsif data.is_a? File
          data = JSON.parse(File.open(data))
        elsif data.is_a? Hash
          # do nothing
        else
          raise NotImplementedError, "Not supported format"
        end
        @kids = data
      end

      def find_by_kid(kid)
        @kids[kid.to_s.strip]
      end
    end
  end
end
