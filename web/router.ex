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

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete

    get "/u", UserController, :index
    get "/u/:id", UserController, :show

    get "/settings", AccountController, :index
    get "/settings/profile", AccountController, :profile
    post "/settings/profile", AccountController, :update_profile
    get "/settings/account", AccountController, :account
    post "/settings/account", AccountController, :update_account
    get "/settings/phones", AccountController, :phone
    post "/settings/phones", AccountController, :add_phone
    delete "/settings/phones/:id", AccountController, :delete_phone
  end
end
