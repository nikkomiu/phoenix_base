defmodule PhoenixBase.Router do
  use PhoenixBase.Web, :router

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
    plug Guardian.Plug.EnsureAuthenticated,
      handler: PhoenixBase.SessionController
  end

  pipeline :browser_no_auth do
    plug Guardian.Plug.EnsureNotAuthenticated,
      handler: PhoenixBase.SessionController
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixBase do
    pipe_through [:browser]

    get "/", PageController, :index
    get "/about", PageController, :about

    get "/login/forgot", SessionController, :forgot
    post "/login/forgot", SessionController, :forgot
    get "/login/unlock/:id", SessionController, :unlock
    get "/login/verify/:id", SessionController, :verify
    get "/login/confirm/:id", SessionController, :confirm
  end

  # Unauthenticated
  scope "/", PhoenixBase do
    pipe_through [:browser, :browser_no_auth]

    get "/login", SessionController, :new
    post "/login", SessionController, :create

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
  end

  # Authenticated
  scope "/", PhoenixBase do
    pipe_through [:browser, :browser_auth]

    get "/logout", SessionController, :delete

    get "/u", UserController, :index
    get "/u/:username", UserController, :show

    get "/settings", AccountSettingsController, :index
    get "/settings/profile", AccountSettingsController, :profile
    post "/settings/profile", AccountSettingsController, :update_profile
    get "/settings/account", AccountSettingsController, :account
    post "/settings/account/password", AccountSettingsController,
      :update_password
    post "/settings/account/username", AccountSettingsController,
      :update_username
    delete "/settings/account", AccountSettingsController, :delete_account
  end
end
