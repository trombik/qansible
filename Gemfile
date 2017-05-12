source "https://rubygems.org"

# Specify your gem"s dependencies in qansible_qa.gemspec
gemspec

gem "rspec", "~> 3.0"

group :development do
  gem "ruby_dep", "~> 1.3.1"
  gem "listen", "~> 3.0.8"
  gem "guard"
  gem "guard-rake"
end

group :test do
  gem "simplecov", :require => false
  gem "coveralls", :require => false
  gem "rubocop", "~> 0.45.0"
  gem "rake", "~> 10.0"
  gem "bundler", "~> 1.12"
end
