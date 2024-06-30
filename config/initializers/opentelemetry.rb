require 'opentelemetry/sdk'
require 'opentelemetry/instrumentation/rack'
require 'opentelemetry/instrumentation/rails'

OpenTelemetry::SDK.configure do |c|
  c.service_name = 'rails-weather-api'
  c.use 'OpenTelemetry::Instrumentation::Rack'
  c.use 'OpenTelemetry::Instrumentation::Rails'
end

Tracer = OpenTelemetry.tracer_provider.tracer('rails-weather-api', '1.0.0')