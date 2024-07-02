# Simple Weather API and Monitoring Integration

- [Simple Weather API and Monitoring Integration](#simple-weather-api-and-monitoring-integration)
  - [API Endpoint](#api-endpoint)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Setup](#setup)
  - [Monitoring](#monitoring)
    - [Inspection and Visualization](#inspection-and-visualization)
    - [A Note on Direct Instrumentation](#a-note-on-direct-instrumentation)
  - [Potential Use Cases](#potential-use-cases)
  - [Recommendations for Improvement](#recommendations-for-improvement)


This simple weather API provides an easy-to-use interface for retrieving current weather data for a given city. The integration with OpenTelemetry ensures that the application is well-monitored, providing insights into key performance metrics. The API provides key weather metrics such as temperature, humidity, and wind speed, fetched from the OpenWeatherMap API and cached in memory.

## API Endpoint

- **GET /weather/current**: Retrieves current weather data for a specified city.
  - **Request**: `GET /weather/current?city={city_name}`
  - **Response**:
    - **Success**: Returns current weather data including temperature, humidity, and wind speed.
    - **Error**: Returns an error message if the city is not found.

For example,

```bash
# curl -i http://localhost:3000/weather/current/Tokyo
HTTP/1.1 200 OK
...
{"temperature":30.44,"humidity":69,"wind_speed":4.12}

# curl -i http://localhost:3000/weather/current/non-existing-city
HTTP/1.1 404 Not Found
...
{"error":"City non-existing-city not found"}
```

## Getting Started

### Prerequisites
- Ruby (version 3.3.3)
- Rails (version 7.1.3)
- OpenWeatherMap API key

### Setup

1. Clone the repository:

```bash
git clone https://github.com/xuebingli/rails-weather-api.git
cd rails-weather-api
```

2. Install dependencies:

```bash
bundle install
```

3. Set up environment variables:

```bash
export OPENWEATHER_API_KEY=<INSERT_YOUR_API_KEY>
```
Update with your OpenWeatherMap API key.

4. Run the Rails server:

```bash
bin/rails server
```
Access the application at http://localhost:3000/weather/current/Tokyo.

## Monitoring

OpenTelemetry has been integrated to collect traces from the application. All default instrumentation is enabled, and custom traces are implemented to enhance observability.

### Inspection and Visualization

Traces and such can be gathered and viewed using a compatible tool, e.g. Jaeger.

```bash
docker run -d --name jaeger \
  -e COLLECTOR_ZIPKIN_HOST_PORT=:9411 \
  -e COLLECTOR_OTLP_ENABLED=true \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 4317:4317 \
  -p 4318:4318 \
  -p 14250:14250 \
  -p 14268:14268 \
  -p 14269:14269 \
  -p 9411:9411 \
  jaegertracing/all-in-one:latest
```

<img width="2390" alt="Screenshot 2024-07-02 at 4 09 05 PM" src="https://github.com/xuebingli/rails-weather-api/assets/1525352/9e77823c-ec9e-4e93-bbdc-2162f9a7cb43">

### A Note on Direct Instrumentation

As OpenTelemetry's Ruby SDK currently [lacks support for metrics](https://opentelemetry.io/docs/languages/ruby/instrumentation/#metrics) and [logs](https://opentelemetry.io/docs/languages/ruby/instrumentation/#logs), direct instrumentation of metrics and logs is infeasible. Therefore, a trace-based workaround is recommended. Special care is taken with traces to ensure that key performance indicators, such as rate, errors, and duration, can be *derived* from traces alone. For example, this can be achieved using Service Performance Monitoring provided by Jaeger. 

![screenshot](https://www.jaegertracing.io/img/frontend-ui/spm.png)


## Potential Use Cases

- **Internal Proxy**: Deploy as an internal proxy server within the organization to provide and cache current weather conditions. This setup reduces external API calls and ensures faster response times for internal applications.
- **Weather Dashboard**: Integrate the weather API with a dashboard to display current weather conditions for various cities. The dashboard can be customized to show specific weather metrics relevant to the organization.
- **Home Automation**: Connect the weather API with home automation systems to dynamically adjust settings such as heating, cooling, and lighting based on current weather conditions.

## Recommendations for Improvement

- **Authentication**: Integrate robust authentication mechanisms to secure customer-facing use cases.
- **API Versioning**: Add support for API versioning to ensure backward compatibility and smooth transitions when introducing new features or making changes to the API.
- **Rate Limiting**: Implement rate limiting to prevent abuse and ensure fair usage of the API.
- **Direct Instrumentation of Metrics and Logs**: Complement OpenTelemetry with another library to enable direct instrumentation of metrics and logs.
- **Dedicated Caching Data Store**: Use a dedicated caching data store, such as Redis, to improve performance.
- **More Product Features**: Expand the API by adding an endpoint that provides 7-day weather forecasts.
