# frozen_string_literal: true

module EuDcc
  class Cwt
    HCERT_CLAIM = -260
    ISSUER_CLAIM = 1
    ISSUED_AT_CLAIM = 6
    EXPIRED_AT_CLAIM = 4
    # noinspection RubyConstantNamingConvention
    DIGITAL_COVID_CERTIFICATE_CLAIM = 1
    NEGATIVE_TEST_RESULT_CODE = "260415000"

    attr_reader :country, :issued_at, :expired_at, :dcc, :payload, :raw_payload

    def initialize(raw_payload)
      @raw_payload = fix_tagged_date(raw_payload)
      @payload = map_payload(@raw_payload).freeze
      @payload.each do |k, v|
        self.instance_variable_set("@#{k}", v)
      end
      @dcc = to_recursive_ostruct(@payload[:dcc])
    end

    def raw
      @raw_payload
    end

    def verify!(validation_date: Time.now,
                verification_steps: [:expiration_check, :future_check])
      if verification_steps.include?(:future_check) && self.issued_at && self.issued_at > validation_date
        raise VerifyError, "DCC issued in future #{self.issued_at}. (#{validation_date})"
      end
      if verification_steps.include?(:expiration_check) && self.expired_at && validation_date > self.expired_at
        raise VerifyError, "DCC expired at #{self.expired_at}"
      end
    end

    protected

      def map_payload(payload)
        {
          country: payload[ISSUER_CLAIM],
          issued_at: payload[ISSUED_AT_CLAIM] && Time.at(payload[ISSUED_AT_CLAIM]).to_datetime,
          expired_at: payload[EXPIRED_AT_CLAIM] && Time.at(payload[EXPIRED_AT_CLAIM]).to_datetime,
          dcc: map_hcert(payload[HCERT_CLAIM][DIGITAL_COVID_CERTIFICATE_CLAIM])
        }
      end

      def map_hcert(dcc)
        {
          version: dcc["ver"],
          subject: {
            family_name: dcc["nam"]["fn"],
            given_name: dcc["nam"]["gn"],
            family_name_transliterated: dcc["nam"]["fnt"],
            given_name_transliterated: dcc["nam"]["gnt"],
          },
          date_of_birth: safe_date_parse(dcc["dob"]),
          vaccinations: dcc["v"]&.map(&method(:map_vaccination_entry)),
          recoveries: dcc["r"]&.map(&method(:map_recovery_entry)),
          test_results: dcc["t"]&.map(&method(:map_test_result_entry)),
        }
      end

      def map_vaccination_entry(vaccination_entry)
        {
          disease_targeted_code: vaccination_entry["tg"],
          disease_targeted_description: CONSTANTS["DiseasesTargeted"][vaccination_entry["tg"]],
          vaccine_type_code: vaccination_entry["vp"],
          vaccine_type: CONSTANTS["VaccineTypes"][vaccination_entry["vp"]],
          product_code: vaccination_entry["mp"],
          product_description: CONSTANTS["VaccineNames"][vaccination_entry["mp"]],
          manufacturer_code: vaccination_entry["ma"],
          manufacturer_description: CONSTANTS["VaccineManufacturers"][vaccination_entry["ma"]],
          dose_number: vaccination_entry["dn"],
          total_number_of_dose: vaccination_entry["sd"],
          date_of_vaccination: DateTime.parse(vaccination_entry["dt"]),
          country: vaccination_entry["co"],
          certificate_issuer: vaccination_entry["is"],
          certificate_id: vaccination_entry["ci"]
        }
      end

      def map_recovery_entry(recovery_entry)
        {
          disease_targeted_code: recovery_entry["tg"],
          disease_targeted_description: CONSTANTS["DiseasesTargeted"][recovery_entry["tg"]],
          date_of_first_positive_result: DateTime.parse(recovery_entry["fr"]),
          certificate_issuer: recovery_entry["is"],
          country: recovery_entry["co"],
          date_valid_from: DateTime.parse(recovery_entry["df"]),
          date_valid_until: DateTime.parse(recovery_entry["du"]),
          certificate_id: recovery_entry["ci"]
        }
      end

      def map_test_result_entry(test_result_entry)
        {
          disease_targeted_code: test_result_entry["tg"],
          disease_targeted_description: CONSTANTS["DiseasesTargeted"][test_result_entry["tg"]],
          antigen_test: test_result_entry["tt"] == "LP217198-3",
          pcr_test: test_result_entry["tt"] ==  "LP6464-4",
          test_type: test_result_entry["tt"],
          test_type_description: CONSTANTS["TestTypes"][test_result_entry["tt"]],
          test_name: test_result_entry["tn"],
          test_manufacturer_code: test_result_entry["ma"],
          test_manufacturer_description: CONSTANTS["TestManufacturers"][test_result_entry["ma"]],
          sample_collected_time: DateTime.parse(test_result_entry["sc"]),
          test_result_code: test_result_entry["tr"],
          test_result_description: CONSTANTS["TestResults"][test_result_entry["tr"]],
          is_negative: test_result_entry["tr"] == NEGATIVE_TEST_RESULT_CODE,
          test_centre: test_result_entry["tc"],
          country_of_test: test_result_entry["co"],
          certificate_issuer: test_result_entry["is"],
          certificate_id: test_result_entry["ci"]
        }
      end

      def safe_date_parse(date_string)
        Date.parse(date_string)
      rescue
        date_string
      end

      def fix_tagged_date(hash)
        # some Date are presented as CBOR:Tagged
        # so we should convert it to string
        def transform(val)
          if val.is_a?(Hash)
            res = fix_tagged_date(val)
          elsif val.is_a?(Array)
            res = val.map { |it| transform(it) }
          elsif val.is_a? CBOR::Tagged
            res = val.value
          else
            res = val
          end
          res
        end

        result = hash.each_with_object({}) do |(key, val), memo|
          memo[key] = transform(val)
        end
        result
      end

      def to_recursive_ostruct(hash)
        def transform(val)
          if val.is_a?(Hash)
            res = OpenStruct.new(val)
          elsif val.is_a?(Array)
            res = val.map { |it| transform(it) }
          else
            res = val
          end
          res
        end

        result = hash.each_with_object({}) do |(key, val), memo|
          memo[key] = transform(val)
        end
        OpenStruct.new(result)
      end
  end
end
