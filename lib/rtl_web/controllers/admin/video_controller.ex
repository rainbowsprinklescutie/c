defmodule RTLWeb.Admin.VideoController do
  use RTLWeb, :controller

  def index(conn, _params) do
    # Instead of rendering a normal view template, we render a Liveview here.
    # The Liveview process is responsible for fetching all needed data.
    live_render(conn, RTLWeb.Admin.VideosListLiveview, session: %{})
  end
end
