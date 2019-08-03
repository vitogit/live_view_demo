defmodule LiveViewDemoWeb.Router do
  use LiveViewDemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Phoenix.LiveView.Flash
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveViewDemoWeb do
    pipe_through :browser
    live "/", MainLive
    live "/room/:room_id", RoomLive
  end

end
