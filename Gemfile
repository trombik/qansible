# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem"s dependencies in qansible_qa.gemspec
gemspec

gem "rspec", "~> 3.0"

group :development do
  gem "guard"
  gem "guard-rake"
  gem "listen", "~> 3.0.8"
end

group :test do
  gem "bundler"
  gem "coveralls", require: false
  gem "rake"
  gem "rubocop"
  gem "simplecov", require: false
end
