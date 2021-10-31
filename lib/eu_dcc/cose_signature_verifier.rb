# frozen_string_literal: true

require "openssl"
require "cose"
require "base64"
module EuDcc
  # noinspection ALL
  class CoseSignatureVerifier
    COSE_SIGNATURE_ALGORITHM_MAPPING = {
      -7 => "SHA256withECDSA",
      -35 => "SHA384withECDSA",
      -36 => "SHA512withECDSA",
      -37 => "SHA256withRSA/PSS",
      -38 => "SHA384withRSA/PSS",
      -39 => "SHA512withRSA/PSS"
    }
    def initialize(trust_list_repository)
      @trust_list_repository = trust_list_repository
    end
    def verify(cose_sign1)
      kid = Base64.encode64(cose_sign1.headers.kid)

      signing_key_info = @trust_list_repository.find_by_kid(kid)
      raise VerifyError, "Can't find kid #{kid}" unless signing_key_info

      cosa_signature_algorithm_code = cose_sign1.protected_headers[1]
      signature_algorithm = short_cose_signature_algorithm(cosa_signature_algorithm_code)

      # Let's support different presentation of public key
      if signing_key_info["publicKeyPem"]
        pem = "-----BEGIN PUBLIC KEY-----\n#{signing_key_info['publicKeyPem']}\n-----END PUBLIC KEY-----"
        if signature_algorithm == :ecdsa
          key = OpenSSL::PKey::EC.new(pem)
        elsif algorithm == :rsa
          key = OpenSSL::PKey::RSA.new(pem)
        else
          raise NotImplementedError, "Unsupported signature algorithm #{cosa_signature_algorithm_code}"
        end
        cose_key = COSE::Key.from_pkey(key)
      elsif signing_key_info["rawData"]
        certificate = OpenSSL::X509::Certificate.new(Base64.decode64(signing_key_info["rawData"]))
        cose_key = COSE::Key.from_pkey(certificate.public_key)
      elsif signing_key_info["alg"]
        if signature_algorithm == :ecdsa
          cose_key = COSE::Key::EC2.new(crv: COSE::Key::Curve.by_name(signing_key_info["crv"]).id,
                                        x: Base64.decode64(signing_key_info["x"]),
                                        y: Base64.decode64(signing_key_info["y"]),
                                        d: nil)
        elsif algorithm == :rsa
          cose_key = COSE::Key::RSA.new(n: Base64.decode64(signing_key_info["n"]),
                                        e: Base64.decode64(signing_key_info["e"]))
        else
          raise NotImplementedError, "Unsupported signature algorithm #{cosa_signature_algorithm_code}"
        end
      else
        raise NotImplementedError
      end

      cose_key.kid = cose_sign1.headers.kid

      cose_sign1.verify(cose_key)
    end
    protected

      def short_cose_signature_algorithm(signature_algorithm_code)
        algorithm = cose_signature_algorithm(signature_algorithm_code)
        if algorithm
          if algorithm.end_with? "ECDSA"
            :ecdsa
          elsif algorithm.end_with? "RSA/PSS"
            :rsa
          else
            nil
          end
        end
      end

      # noinspection RubyParameterNamingConvention
      def cose_signature_algorithm(signature_algorithm_code)
        COSE_SIGNATURE_ALGORITHM_MAPPING[signature_algorithm_code]
      end
  end
end
