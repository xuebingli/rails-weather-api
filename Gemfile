source "https://rubygems.org"

ruby "3.3.3"

gem "rails", "~> 7.1.3", ">= 7.1.3.4"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
end

group :test do
  gem 'rspec-rails'
  gem 'webmock'
end

# Integrate OpenTelemetry for monitoring-in-code
gem "opentelemetry-sdk", "~> 1.4"
gem "opentelemetry-instrumentation-all", "~> 0.61.0"
gem "opentelemetry-exporter-otlp", "~> 0.28.0"

# Use httparty to call OpenWeather API
gem "httparty", "~> 0.22.0"
