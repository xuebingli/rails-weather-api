class ApplicationController < ActionController::API
  around_action :with_span

  private

  def with_span(&block)
    Tracer.in_span("#{controller_name}##{action_name}") do |span|
      span.add_attributes({
        OpenTelemetry::SemanticConventions::Trace::HTTP_METHOD => request.method,
        OpenTelemetry::SemanticConventions::Trace::HTTP_ROUTE => request.path,
        OpenTelemetry::SemanticConventions::Trace::HTTP_USER_AGENT => request.user_agent,
      })
      begin
        block.call
        span.set_attribute(OpenTelemetry::SemanticConventions::Trace::HTTP_STATUS_CODE,  response.status)
      rescue => e
        span.status = OpenTelemetry::Trace::Status.error("Unexpected exception")
        span.record_exception(e)
        raise e
      end
    end
  end
end
