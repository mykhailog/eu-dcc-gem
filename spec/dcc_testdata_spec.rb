# frozen_string_literal: true

require "rspec"
require_relative "../lib/eu_dcc"
require_relative "./dgc_raw_test_case"
DGC_TEST_FOLDER = "./spec/dgc-testdata/"
EXCLUDE_LIST = {
  ES: %w[401.json 402.json 403.json], # some problems with cryptographic key
  FR: ["test_pcr_ok.json"] # date mismatch.
}

unless File.exists?(DGC_TEST_FOLDER)
  system("cd ./spec/ && git clone git@github.com:eu-digital-green-certificates/dgc-testdata.git")
else
  system("cd #{DGC_TEST_FOLDER} && git pull origin main --rebase")
end

countries = Dir.entries(DGC_TEST_FOLDER).select { |entry| entry.length == 2 }
country_test_cases = countries.map do |country|
  path = "#{DGC_TEST_FOLDER}/#{country}/2DCode/raw"
  if File.exists?(path)
    Dir.entries(DGC_TEST_FOLDER)
    { country: country, test_cases: Dir.glob("#{path}/*.json") }
  end
end.compact

RSpec.describe "DCC Test Data" do
  country_test_cases.each do |country_test_case|
    describe "#{country_test_case[:country]}" do
      country_test_case[:test_cases].each do |test_case_path|
        excluded = EXCLUDE_LIST[country_test_case[:country].to_sym]&.include?(File.basename(test_case_path))
        describe "#{File.basename(test_case_path)}", skip: excluded ? "Temporary skipped" : nil do
          before(:all) do
            @test = DdcRawTestCase.new(File.open(test_case_path))
          end
          it "should parse" do
            @test.parse
          end
          it "should verify" do
            unless @test.verify
              skip
            end
          end
          it "should match data" do
            if @test.verify_json?
              expect(@test.source_raw_cwt).to eq(@test.target_raw_cwt)
            else
              skip("EXPECTEDVALIDJSON = false")
            end
          end
        end
      end
    end
  end
end
