# Phoenix
> Realtime Elixir Web Framework

## Goals
- First class websockets
- Ring distribution

## Creating a new Phoenix application

```console
mix phoenix.new your_app /path/to
```

## Usage

```elixir
defmodule Router do
  use Phoenix.Router, port: 4000

  get "pages/:page", Controllers.Pages, :show, as: :page
  get "files/*path", Controllers.Files, :show
  get "profiles/user-:id", Controllers.Users, :show

  resources "users", Controllers.Users do
    resources "comments", Controllers.Comments
  end
end

defmodule Controllers.Pages do
  use Phoenix.Controller

  def show(conn) do
    if conn.params["page"] in ["admin"] do
      redirect conn, Router.page_path(page: "unauthorized")
    else
      text conn, "Showing page #{conn.params["page"]}"
    end
  end

end

defmodule Controllers.Users do
  use Phoenix.Controller

  def show(conn) do
    text conn, "Showing user #{conn.params["id"]}"
  end

  def index(conn) do
    html conn, """
    <html>
      <body>
        <h1>Users</h1>
      </body>
    </html>
    """
  end
end
```

## Mix Tasks

### Print all routes

```bash
$ mix phoenix.routes Router

             page  GET     pages/:page                       Elixir.Controllers.Pages#show
                   GET     files/*path                       Elixir.Controllers.Files#show
                   GET     profiles/user-:id                 Elixir.Controllers.Users#show
            users  GET     users                             Elixir.Controllers.Users#index
        edit_user  GET     users/:id/edit                    Elixir.Controllers.Users#edit
             user  GET     users/:id                         Elixir.Controllers.Users#show
         new_user  GET     users/new                         Elixir.Controllers.Users#new
                   POST    users                             Elixir.Controllers.Users#create
                   PUT     users/:id                         Elixir.Controllers.Users#update
                   PATCH   users/:id                         Elixir.Controllers.Users#update
                   DELETE  users/:id                         Elixir.Controllers.Users#destroy
    user_comments  GET     users/:user_id/comments           Elixir.Controllers.Comments#index
edit_user_comment  GET     users/:user_id/comments/:id/edit  Elixir.Controllers.Comments#edit
     user_comment  GET     users/:user_id/comments/:id       Elixir.Controllers.Comments#show
 new_user_comment  GET     users/:user_id/comments/new       Elixir.Controllers.Comments#new
                   POST    users/:user_id/comments           Elixir.Controllers.Comments#create
                   PUT     users/:user_id/comments/:id       Elixir.Controllers.Comments#update
                   PATCH   users/:user_id/comments/:id       Elixir.Controllers.Comments#update
                   DELETE  users/:user_id/comments/:id       Elixir.Controllers.Comments#destroy
```

## Starting the application

```bash
$ mix run -e 'Router.start' --no-halt mix.exs
```

