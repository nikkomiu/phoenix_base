defmodule AwesomeApp.Router do
  use AwesomeApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :browser_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: AwesomeApp.SessionController
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AwesomeApp do
    pipe_through [:browser]

    get "/", PageController, :index
    get "/about", PageController, :about

    get "/login", SessionController, :new
    post "/login", SessionController, :create

    get "/login/forgot", SessionController, :forgot
    post "/login/forgot", SessionController, :forgot
    get "/login/confirm/:id", SessionController, :confirm_account
    get "/login/unlock/:id", SessionController, :unlock_account
  end

  scope "/", AwesomeApp do
    pipe_through [:browser, :browser_auth]

    get "/logout", SessionController, :delete

    get "/u", UserController, :index
    get "/u/:id", UserController, :show

    get "/settings", AccountSettingsController, :index
    get "/settings/profile", AccountSettingsController, :profile
    post "/settings/profile", AccountSettingsController, :update_profile
    get "/settings/account", AccountSettingsController, :account
    post "/settings/account/password", AccountSettingsController, :update_password
    post "/settings/account/username", AccountSettingsController, :update_username
    delete "/settings/account", AccountSettingsController, :delete_account
    get "/settings/emails", AccountSettingsController, :emails
    post "/settings/emails", AccountSettingsController, :add_email
    delete "/settings/emails/:id", AccountSettingsController, :delete_email
    get "/settings/phones", AccountSettingsController, :phones
    post "/settings/phones", AccountSettingsController, :add_phone
    delete "/settings/phones/:id", AccountSettingsController, :delete_phone
  end
end
