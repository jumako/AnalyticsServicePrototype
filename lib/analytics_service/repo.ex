defmodule AnalyticsService.Repo do
  use Ecto.Repo,
    otp_app: :analytics_service,
    adapter: Ecto.Adapters.Postgres
end
