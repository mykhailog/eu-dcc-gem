# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }
unless /java/ === RUBY_PLATFORM
  gem "cose"
  gem "cbor"
end

# Specify your gem's dependencies in eu_dcc.gemspec
gemspec
