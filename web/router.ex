defmodule AwesomeApp.Router do
  use AwesomeApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AwesomeApp do
    pipe_through :browser

    get "/", PageController, :index
    get "/about", PageController, :about
  end
end
