defmodule PhoenixBase.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use PhoenixBase.Web, :controller
      use PhoenixBase.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model_store do
    quote do
      alias PhoenixBase.Repo

      import Ecto.Query
    end
  end

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      import PhoenixBase.Router.Helpers
      import PhoenixBase.Gettext
      import PhoenixBase.UserHelper

      alias PhoenixBase.Repo
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller,
          only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import PhoenixBase.Router.Helpers
      import PhoenixBase.ErrorHelpers
      import PhoenixBase.Gettext
      import PhoenixBase.ViewHelpers
      import PhoenixBase.UserHelper
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias PhoenixBase.Repo
      import Ecto
      import Ecto.Query
      import PhoenixBase.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
