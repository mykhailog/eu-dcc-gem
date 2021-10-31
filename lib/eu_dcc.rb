# frozen_string_literal: true

require_relative "eu_dcc/version"
require_relative "eu_dcc/base45"
require_relative "eu_dcc/constants"
require_relative "eu_dcc/health_certificate"
require_relative "eu_dcc/cwt"
require_relative "eu_dcc/cose_signature_verifier"
require_relative "eu_dcc/trust_list_repository/local"
require_relative "eu_dcc/trust_list_repository/web"
require_relative "eu_dcc/trust_list_repository/test"
require_relative "eu_dcc/covid_check_result"

require_relative "eu_dcc/verify_error"
module EuDcc
  class Error < StandardError; end
  # Your code goes here...
end
