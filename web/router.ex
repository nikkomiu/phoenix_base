defmodule AwesomeApp.Router do
  use AwesomeApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AwesomeApp do
    pipe_through [:browser, :browser_auth]

    get "/", PageController, :index
    get "/about", PageController, :about

    get "/auth/login", SessionController, :new
    post "/auth/login", SessionController, :create
    get "/auth/logout", SessionController, :delete
  end
end
