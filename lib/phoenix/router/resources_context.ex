defmodule Phoenix.Router.ResourcesContext do
  alias Phoenix.Router.Path
  alias Phoenix.Router.Stack

  @stack_name :nested_resources

  @moduledoc """
  Helper functions for pushing and popping nested Route resources
  and maintaining resource state during nested expansion
  """

  @doc """
  Returns the String route path based on current context
  of module and relative path.

  ## Examples

      resources "users", Users do
        resources "comments", Comments
        -------------------------------
        Context.current_path("comments")
        => "users/:user_id/comments"
        -------------------------------
      end
      resources "pages", Pages
      ---------------------------------
      Context.current_path("pages")
      => "pages"
      ---------------------------------

  """
  def current_path(relative_path, module) do
    case get(module) do
      []        -> relative_path
      resources -> resources
                   |> Enum.reverse
                   |> Enum.map(&resource_with_named_param(&1))
                   |> Kernel.++([relative_path])
                   |> Path.join
    end
  end

  @doc """
  Returns the current alias of the route given module's nested context

  ## Examples

      resources "users", Users do
        resources "comments", Comments
        -------------------------------
        Context.current_alias(:index, "comments", __MODULE__)
        => "user_comments"
        Context.current_alias(:show, "comments", __MODULE__)
        => "user_comment"
        Context.current_alias(:edit, "comments", __MODULE__)
        => "edit_user_comment"
        -------------------------------
      end
      resources "pages", Pages
      ---------------------------------
      Context.current_alias("users", __MODULE__)
      => "users"
      Context.current_alias("comments", __MODULE__)
      => "users_comments"
      ---------------------------------

  """
  def current_alias(relative_path, module) do
    [relative_path | get(module)]
    |> Enum.reverse
    |> Enum.join("_")
  end

  @doc """
  Pushes the current resource onto resources stack
  """
  def push(resource, module) do
    Stack.push(resource, @stack_name, module)
  end

  @doc """
  Pops the current resource off resources stack
  """
  def pop(module) do
    Stack.pop(@stack_name, module)
  end

  defp get(module) do
    Stack.get(@stack_name, module)
  end

  @doc """
  Appends the singularized inflection of named resource parameter based
  on current route resource

  ## Examples

      iex> Phoenix.Router.Context.resource_with_named_param("users")
      "users/:user_id"

  """
  def resource_with_named_param(resource) do
    Path.join([resource, ":#{Inflex.singularize(resource)}_id"])
  end
end

