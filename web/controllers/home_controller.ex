defmodule EducateYour.HomeController do
  use EducateYour.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
