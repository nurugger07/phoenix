defmodule Phoenix.Router.ControllerTest do
  use ExUnit.Case
  use PlugHelper

  defmodule RedirController do
    use Phoenix.Controller
    def redir_301(conn) do
      redirect conn, 301, "/users"
    end
    def redir_302(conn) do
      redirect conn, "/users"
    end
  end

  defmodule Controllers.Page do
    use Phoenix.Controller

    @user_haml %s{
      %section.container
        %article
          %h1 Phoenix
          %h2 An Elixir Web Framework
          #main.content
            This was rendered by Calliope
    }

    def show(conn) do
      haml conn, @user_haml
    end

  end

  defmodule Router do
    use Phoenix.Router
    get "users/not_found_301", RedirController, :redir_301
    get "users/not_found_302", RedirController, :redir_302

    get "page", Controllers.Page, :show
  end

  test "redirect without status performs 302 redirect do url" do
    {:ok, conn} = simulate_request(Router, :get, "users/not_found_302")
    assert conn.status == 302
  end

  test "redirect without status performs 301 redirect do url" do
    {:ok, conn} = simulate_request(Router, :get, "users/not_found_301")
    assert conn.status == 301
  end

  test "controller renders haml" do
    {:ok, conn} = simulate_request(Router, :get, "page")
    IO.puts inspect conn
    assert conn.status == 200
    assert conn.resp_body == "<section class=\"container\"></section><article></article><h1>Phoenix</h1><h2>An Elixir Web Framework</h2><div id=\"main\" class=\"content\">This was rendered by Calliope</div>"
  end

end
