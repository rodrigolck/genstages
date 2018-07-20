defmodule GenstagesWeb.Router do
  use GenstagesWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GenstagesWeb do
    pipe_through :api
  end
end
