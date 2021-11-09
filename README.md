# EU COVID Certificate Library

An implementation in Ruby for decoding and validating a EU Digital COVID Certificate.

The Digital COVID Certificate (DCC) is digital proof that a person has been vaccinated against COVID-19, received a negative test result, or recovered from COVID-19. 

*NOTICE: This not an official validator! It comes without any waranties*

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eu_dcc', github: 'mykhailog/eu-dcc-ruby'
```

And then execute:

    $ bundle install

## Usage

#### Parse certificate from QR-code payload

```ruby
# Barcode payload is text recognized from QR code.
# It should starts from "HC1:" 
BARCODE_PAYLOAD = "HC1:NCFOXN%TSMAHN-HMVKBB7 IV+%U+/U0IIDOM 435G8/EB*C2..."

cert = EuDcc::HealthCertificate.from_payload(BARCODE_PAYLOAD)
```
#### Parse certificate from QR-code image
```ruby
  # to use recognition from QR code add zxing gem to your Gemfile
  cert = EuDcc::HealthCertificate.from_qrcode("1.png")
  # or by url
  cert = EuDcc::HealthCertificate.from_qrcode("https://raw.githubusercontent.com/eu-digital-green-certificates/dgc-testdata/main/UA/png/1.png")
```

# Verification
```ruby
# Verify if certificate is valid.
# 
# Certificate is valid when it signed with trusted issuer
# and it is not expired.
# 
# If certificate is not valid VerifyError will be raised
#
cert = EuDcc::HealthCertificate.from_qrcode("1.png")
cert.verify!

# or use safe method returns true or false 
cert.verify
```



# Information
```ruby
cert = EuDcc::HealthCertificate.from_qrcode("1.png")

puts cert.data          # get structured information
# <OpenStruct version="1.3.0", subject=#<OpenStruct family_name="Ткаченко", given_name="Мар'яна",...
puts cert.to_h          # get information as a hash
# {:country=>"UA", :issued_at=>#<DateTime: 2021-06-22T16:07:51+03:00 ((2459388j,47271s,0n),+10800s,2299161j)>, ...
puts cert.cwt_hash      # get raw information
# {1=>"UA", 4=>1629551271, 6=>1624367271, -260=>{1=>{"ver"=>"1.3.0", "nam"=>{"fn"=>"Ткаченко"...
puts cert.issued_at     
# 2021-06-22T16:07:51+03:00
puts cert.expired_at    
# 2021-08-21T16:07:51+03:00
puts cert.country  
# UA
```
# COVID Result Check
```ruby
cert.check_result
# {:valid=>true, :source=>:vaccination, :fully_vacinated=>false, :reason=>nil}

# check_result has various options which 
# depends on country COVID policy
# 
cert.check_result({ 
  allow_vaccinated: true,
  allow_vaccinated_min: 14.days,
  allow_vaccinated_max: 365.days,
  allow_vaccines: ["EU/1/20/1528", "EU/1/20/1507", "EU/1/21/1529","EU/1/20/1525"], # EMA Approved vaccines
  allow_partially_vaccinated: true,
  allow_cured: true,
  allow_cured_min: nil,
  allow_cured_max: nil,
  ignore_cured_date_valid: false,
  allow_tested_pcr: true,
  allow_tested_pcr_min: 0,
  allow_tested_pcr_max: 72.hour,
  allow_tested_antigen_unknown: 0,
  allow_tested_antigen_unknown_min: 0,
  allow_tested_antigen_unknown_max: 48.hour
})
# {:valid=>false, :source=>:vaccination, :fully_vacinated=>true, :reason=>"Vaccine CoronaVac is not allowed"}
```

# TODO
- Write tests
- Get constants from github repository


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mykhailog/eu-dcc-ruby.

