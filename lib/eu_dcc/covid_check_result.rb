# frozen_string_literal: true

module EuDcc
  class CovidCheckResult
    DAYS = 1
    HOUR = 3600 / 86400
    MINUTES = 60 / 86400
    DEFAULT_OPTIONS = { allow_vaccinated: true,
                        allow_vaccinated_min: 14 * DAYS,
                        allow_vaccinated_max: 365 * DAYS,
                        allow_vaccines: %w[EU/1/20/1528 EU/1/20/1507 EU/1/21/1529 EU/1/20/1525],
                        allow_partially_vaccinated: true,
                        allow_cured: true,
                        allow_cured_min: nil,
                        allow_cured_max: nil,
                        ignore_cured_date_valid: false,
                        allow_tested_pcr: true,
                        allow_tested_pcr_min: 0,
                        allow_tested_pcr_max: 72 * HOUR,
                        allow_tested_antigen_unknown: 0,
                        allow_tested_antigen_unknown_min: 0,
                        allow_tested_antigen_unknown_max: 48 * HOUR,
                        current_date: nil }

    def initialize(payload)
      @payload = payload
    end

    def check_result(options = {})
      options = DEFAULT_OPTIONS.merge(options)
      options[:current_date] = DateTime.now if options[:current_date].nil?
      check_vaccination(options) || check_test(options) || check_recovery(options) || invalid_result
    end

    protected

      def check_test(options)
        test = @payload.test_results&.first
        if test

          if test.antigen_test
            test_type = "antigen_unknown"
          elsif test.pcr_test
            test_type = "pcr"
          else
            test_type = nil
          end

          valid = true
          reason = nil
          if test_type
            if options["allow_tested_#{test_type}".to_sym]
              unless test.is_negative
                valid = false
                reason = "Positive test result"
              end
              if valid && options["allow_tested_#{test_type}_min".to_sym]
                min_test_date = test.sample_collected_time + options["allow_tested_#{test_type}_min".to_sym]
                valid = min_test_date <= options[:current_date]
                unless valid
                  reason = "Test result is not valid before #{min_test_date}. Current date is #{options[:current_date]}"
                end
              end
              if valid && options["allow_tested_#{test_type}_max".to_sym]
                max_test_date = test.sample_collected_time + options["allow_tested_#{test_type}_max".to_sym]
                valid = max_test_date >= options[:current_date]
                unless valid
                  reason = "Test result is not valid after #{max_test_date}. Current date is #{options[:current_date]}"
                end
              end
            else
              valid = false
              reason = "Test results are not allowed"
            end
          else
            valid = false
            reason = "Unknown test type #{test.test_type}"
          end
          {
            valid: valid,
            type: test_type,
            source: :test_result,
            reason: reason
          }
        end
      end

      def check_vaccination(options)
        vaccination = @payload.vaccinations&.first
        if vaccination && options[:allow_vaccinated]
          fully_vaccinated = vaccination.dose_number == vaccination.total_number_of_dose
          valid = true
          reason = nil
          if options[:allow_vaccines] && !options[:allow_vaccines].include?(vaccination.product_code)
            valid = false
            reason = "Vaccine #{vaccination.product_code} is not allowed."

          end
          if valid && !fully_vaccinated && !options[:allow_partially_vaccinated]
            valid = false
            reason = "Partially vaccination is not allowed"

          end
          if valid && options[:allow_vaccinated_min]
            vaccination_min_date = vaccination.date_of_vaccination + options[:allow_vaccinated_min]
            valid = vaccination_min_date <= options[:current_date]
            unless valid
              reason = "Vaccination is not valid before #{vaccination_min_date}. Current date is #{options[:current_date]}"
            end
          end
          if valid && options[:allow_vaccinated_max]
            vaccination_max_date = vaccination.date_of_vaccination + options[:allow_vaccinated_max]
            valid = vaccination_max_date >= options[:current_date]
            unless valid
              reason = "Vaccination is not valid after #{vaccination_max_date}. Current date is #{options[:current_date]}"
            end
          end
          {
            valid: valid,
            source: :vaccination,
            fully_vacinated: fully_vaccinated,
            reason: reason
          }
        end
      end

      def check_recovery(options)
        recovery = @payload.recoveries&.first
        if recovery && options[:allow_cured]
          valid = true
          reason = nil

          if valid && options[:allow_cured_min]
            min_cured_date = recovery.date_of_first_positive_result + options[:allow_cured_min]
            valid = min_cured_date <= options[:current_date]
            unless valid
              reason = "Recovery result is not valid before #{min_cured_date}. Current date is #{options[:current_date]}"
            end
          end
          if valid && options[:allow_cured_max]
            max_cured_date = recovery.date_of_first_positive_result + options[:allow_cured_max]
            valid = max_cured_date >= options[:current_date]
            unless valid
              reason = "Recovery result is not valid after #{max_cured_date}. Current date is #{options[:current_date]}"
            end
          end
          unless options[:ignore_cured_date_valid]
            if valid
              valid = recovery.date_valid_from <= options[:current_date]
              unless valid
                reason = "Recovery result is not valid before #{recovery.date_valid_from}. Current date is #{options[:current_date]}"
              end
            end
            if valid
              valid = recovery.date_valid_until >= options[:current_date]
              unless valid
                reason = "Recovery result is not valid after #{recovery.date_valid_until}. Current date is #{options[:current_date]}"
              end
            end
          end

          {
            valid: valid,
            source: :recovery,
            reason: reason
          }
        end
      end
      def invalid_result
        {
          valid: false,
          source: nil,
          reason: "No proof found"
        }
      end
  end
end
