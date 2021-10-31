# frozen_string_literal: true

class DdcRawTestCase
  def initialize(source)
    if source.is_a? File
      data = source.read
    elsif source.is_a? Hash
      data = source
    elsif source.is_a? String
      if source.start_with?("http")
        data = download_json(source)
      else
        data = source
      end
    end
    @data = data.is_a?(Hash) ? data : JSON.parse(data)
  end

  def parse
    @cert = EuDcc::HealthCertificate.from_barcode_payload(@data["PREFIX"])
  end

  def verify
    steps = []
    expected_results = @data["EXPECTEDRESULTS"]

    steps.push(:expiration_check) if expected_results["EXPECTEDEXPIRATIONCHECK"]
    steps.push(:cose_signature_verification) if expected_results["EXPECTEDVERIFY"]

    @cert.verify!(trust_list_repository: EuDcc::TrustListRepository::Test.new(@data["TESTCTX"]),
                  validation_date: DateTime.parse(@data["TESTCTX"]["VALIDATIONCLOCK"],
                  ), verification_steps: steps)
    !steps.empty?

    # puts @data["TESTCTX"]["DESCRIPTION"]
    # puts @cert.check_result(current_date: DateTime.parse(@data["TESTCTX"]["VALIDATIONCLOCK"]  ))
  end

  def source_raw_cwt
    JSON.parse(@cert.cwt_hash[-260][1].to_json)
  end

  def target_raw_cwt
    @data["JSON"]
  end

  def verify_json?
    @data["EXPECTEDRESULTS"]["EXPECTEDVALIDJSON"]
  end

  protected

    def download_json(url)
      uri = URI(url)
      response = Net::HTTP.get(uri)
      JSON.parse(response)
    end
end
