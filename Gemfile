source "https://rubygems.org"

# Specify your gem"s dependencies in ansible_qa.gemspec
gemspec
gem "rubocop"
gem "rake"
gem "rspec"

group :development do
  gem "ruby_dep", "~> 1.3.1"
  gem "listen", "~> 3.0.8"
  gem "guard"
  gem "guard-rake"
end

group :test do
  gem "simplecov", :require => false
  gem "coveralls", :require => false
end
