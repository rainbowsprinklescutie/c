defmodule RTLWeb.Manage.UserController do
  use RTLWeb, :controller
  alias RTL.Accounts

  plug :load_user when action in [:show, :edit, :update, :delete]
  plug :must_be_superadmin

  def index(conn, _params) do
    users = Accounts.get_users(preload: :projects)
    render conn, "index.html", users: users
  end

  def show(conn, _params) do
    # conn.assigns.user is already loaded
    render conn, "show.html"
  end

  def new(conn, _params) do
    changeset = Accounts.new_user_changeset()
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.insert_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created.")
        |> redirect(to: Routes.manage_user_path(conn, :show, user.id))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Please see errors below.")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, _params) do
    changeset = Accounts.user_changeset(conn.assigns.user)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    case Accounts.update_user(conn.assigns.user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated.")
        |> redirect(to: Routes.manage_user_path(conn, :show, user.id))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Please see errors below.")
        |> render("edit.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    Accounts.delete_user!(conn.assigns.user)

    conn
    |> put_flash(:info, "User deleted.")
    |> redirect(to: Routes.manage_user_path(conn, :index))
  end

  #
  # Helpers
  #

  defp load_user(conn, _) do
    id = conn.params["id"]
    assign(conn, :user, Accounts.get_user!(id))
  end
end
