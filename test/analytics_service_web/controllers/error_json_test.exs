defmodule AnalyticsServiceWeb.ErrorJSONTest do
  use AnalyticsServiceWeb.ConnCase, async: true

  test "renders 404" do
    assert AnalyticsServiceWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert AnalyticsServiceWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
