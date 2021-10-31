# frozen_string_literal: true

module EuDcc
  module TrustListRepository
    class GithubMirror < Web
      SOURCE_URL_TEMPLATE = "https://raw.githubusercontent.com/section42/hcert-trustlist-mirror/main/%s"
      COUNTRY_TRUST_LIST = {
        at: "trustlist_at.min.json",
        ch: "trustlist_ch.min.json",
        de: "trustlist_de.min.json",
        fr: "trustlist_fr.min.json",
        nl: "trustlist_nl.min.json"
      }

      def initialize(country_code = :de)
        warn "⚠️ GithubMirror use mirror provided using github repository #{SOURCE_URL_TEMPLATE}. It is not official source so it may contain not valid data. Use TrustListRepository::Web or TrustListRepository::Local if you have access to trust list repository.""  "

        if COUNTRY_TRUST_LIST.key?(country_code.to_sym)
          url = SOURCE_URL_TEMPLATE % COUNTRY_TRUST_LIST[country_code]
        else
          raise ArgumentError, "Unsupported country code '#{country_code}'. Allowed values: #{COUNTRY_TRUST_LIST.keys.join(", ")}"
        end
        super(url)
      end
    end
  end
end
