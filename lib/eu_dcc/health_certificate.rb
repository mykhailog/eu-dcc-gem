# frozen_string_literal: true

#
require "cose"
require "cbor"
require "date"
require "zlib"
require "json"
require "ostruct"
require "base64"
require_relative "constants"
module EuDcc
  class HealthCertificate
    HC_CONTEXT_IDENTIFIER = "HC1:" # Health Certificate version 1

    def self.from_payload(barcode_payload)
      raise ArgumentError, "Barcode data should be a string" unless barcode_payload.is_a?(String)
      instance = self.new
      instance.send :parse_barcode_payload, barcode_payload
      instance
    end
    def self.from_qrcode(qrcode)
      require "zxing"
      from_payload(ZXing.decode(qrcode))
    rescue LoadError => e
      warn "zxing gem is missed.\n Please add \"gem 'zxing'\" to your gemfile to support recognition of qrcode."
      raise e
    end

    def verify!(trust_list_repository:,
                validation_date: nil,
                verification_steps: [:cose_signature_verification,
                                     :future_check,
                                     :expiration_check])
      if trust_list_repository.nil?
        trust_list_repository = TrustListRepository::GithubMirror.new
      end
      validation_date = DateTime.now if validation_date.nil?
      if verification_steps.include?(:cose_signature_verification)
        unless CoseSignatureVerifier.new(trust_list_repository).verify(@cose_sign1_object)
          raise VerifyError, "Invalid COSE signature"
        end
      end

      @cwt.verify!(validation_date: validation_date, verification_steps: verification_steps)
      true
    end

    def verify(**params)
      verify!(**params)
    rescue VerifyError
      false
    end

    def check_result(options = {})
      CovidCheckResult.new(info).check_result(options)
    end


    def info
      @cwt.dcc
    end
    alias_method :data, :info

    def issued_at
      @cwt.issued_at
    end
    def expired_at
      @cwt.expired_at
    end
    def country
      @cwt.country
    end

    def cwt_hash
      @cwt.raw_payload
    end
    def cwt
      @cwt
    end
    def as_json
      to_h
    end
    def to_h
      @cwt.payload
    end
    def to_json
      to_h.to_json
    end
    def inspect
      to_h
    end
    def to_s
      JSON.pretty_generate(cert.as_json)
    end

    protected
      def initialize
        end
      def parse_barcode_payload(barcode_payload)
        prefix = barcode_payload[0..HC_CONTEXT_IDENTIFIER.length - 1]

        if prefix != HC_CONTEXT_IDENTIFIER
          raise ArgumentError, "Missing Health Certificate context identifier. Barcode payload should starts with #{HC_CONTEXT_IDENTIFIER}"
        end

        base45_data = barcode_payload[HC_CONTEXT_IDENTIFIER.length..-1]

        decoded_base45_data = Base45.decode45(base45_data)
        if decoded_base45_data[0] == "x" # This is header for zlib
          cose_signed_message = Zlib::Inflate.inflate(decoded_base45_data)
        else
          cose_signed_message = decoded_base45_data
        end
        @cose_sign1_object = COSE::Sign1.deserialize(cose_signed_message)

        cbor = @cose_sign1_object.payload
        @cwt = Cwt.new(CBOR.decode(cbor))
      end
  end
end
