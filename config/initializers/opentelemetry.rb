require 'opentelemetry/sdk'
require 'opentelemetry/instrumentation/all'
require 'opentelemetry-exporter-otlp'

class SanitizeApiKeyProcessor < OpenTelemetry::SDK::Trace::SpanProcessor
  HTTP_TARGET = 'http.target'.freeze
  NET_PEER_NAME = 'net.peer.name'.freeze
  API_HOST = 'api.openweathermap.org'.freeze
  API_KEY_PARAM = 'appid'.freeze

  def on_start(span, parent_context)
    return unless span.attributes.has_key?(HTTP_TARGET)
    return unless span.attributes[NET_PEER_NAME] == API_HOST
    sanitized_url = sanitize_url(span.attributes[HTTP_TARGET])
    span.set_attribute(HTTP_TARGET, sanitized_url)
  end

  private

  def sanitize_url(url)
    uri = URI.parse(url)
    query_params = Rack::Utils.parse_query(uri.query)
    query_params.delete(API_KEY_PARAM) # Remove OpenWeather API key
    uri.query = Rack::Utils.build_query(query_params)
    uri.to_s
  end
end

OpenTelemetry::SDK.configure do |c|
  c.service_name = 'rails-weather-api'
  c.use_all()

  # Configure the sanitization processor and the OTLP exporter
  c.add_span_processor(SanitizeApiKeyProcessor.new)
  c.add_span_processor(
    OpenTelemetry::SDK::Trace::Export::BatchSpanProcessor.new(
      OpenTelemetry::Exporter::OTLP::Exporter.new
    )
  )
end
