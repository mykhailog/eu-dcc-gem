# frozen_string_literal: true

require "net/http"
require "json"
module EuDcc
  module EuDcc
    module TrustListRepository
      class Web
        def initialize(url)
          download!(url)
        end

        def find_by_kid(kid)
          @kids[kid.to_s.strip]
        end

        protected

          def download!(url)
            data = download_json(url)

            if data.is_a? Hash
              # converter from German, Sweden and Austria sources
              if data["certificates"]
                @kids = data["certificates"].map { |v| [v["kid"], v] }.to_h
                # converter from Netherlands
              elsif data["eu_keys"]
                @kids = data["eu_keys"].map { |k, v| [k, { "publicKeyPem" => v.first["subjectPk"] }] }.to_h
              else
                @kids = data.map { |k, v| [k, v.is_a?(Array) ? v.first : v] }.to_h
              end
            else
              raise NotImplementedError, "Unsupported public key repository #{url}"
            end
          end

          def download_json(url)
            uri = URI(url)
            response = Net::HTTP.get(uri)
            JSON.parse(response)
          end
      end
    end
  end
end
