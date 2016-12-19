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

    get "/login/forgot", UnlockController, :forgot_password
    post "/login/forgot", UnlockController, :forgot_password_submit
    get "/login/reset", UnlockController, :password_reset
    put "/login/reset", UnlockController, :complete_password_reset
    get "/login/unlock", UnlockController, :unlock_account
    get "/login/verify", UnlockController, :verify_account
    get "/login/confirm", UnlockController, :confirm_email
  end

  # Unauthenticated
  scope "/", PhoenixBase do
    pipe_through [:browser, :browser_no_auth]

    get "/login", SessionController, :new
    post "/login", SessionController, :create

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
    get "/register/complete", RegistrationController, :complete_registration
    post "/register/complete", RegistrationController, :complete_registration
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
