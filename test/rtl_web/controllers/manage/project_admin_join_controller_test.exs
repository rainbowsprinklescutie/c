defmodule RTLWeb.Manage.ProjectAdminJoinControllerTest do
  use RTLWeb.ConnCase, async: true
  alias RTL.Projects

  describe "plugs" do
    test "all actions reject non-logged-in user", %{conn: conn} do
      conn = get(conn, Routes.manage_user_path(conn, :index))

      assert redirected_to(conn) == Routes.home_path(conn, :index)
      assert conn.halted
    end

    test "all actions reject non-superadmin", %{conn: conn} do
      {conn, _user} = login_as_new_user(conn, %{email: "normal-guy@example.com"})

      conn = get(conn, Routes.manage_user_path(conn, :index))

      assert redirected_to(conn) == Routes.home_path(conn, :index)
      assert conn.halted
    end
  end

  describe "#create" do
    test "inserts the join and redirects", %{conn: conn} do
      {conn, _user} = login_as_superadmin(conn)
      project = Factory.insert_project()
      user = Factory.insert_user()
      assert !Projects.is_project_admin?(project, user)

      params = %{"project_id" => project.id, "admin_id" => user.id, "return_to" => "/abcdef"}
      conn = post(conn, Routes.manage_project_admin_join_path(conn, :create), params)

      assert Projects.is_project_admin?(project, user)
      assert redirected_to(conn) == "/abcdef"
    end
  end

  describe "#delete" do
    test "deletes the join and redirects", %{conn: conn} do
      {conn, _user} = login_as_superadmin(conn)
      project = Factory.insert_project()
      user = Factory.insert_user()
      Projects.add_project_admin!(project, user)
      assert Projects.is_project_admin?(project, user)

      params = %{"project_id" => project.id, "admin_id" => user.id, "return_to" => "/abcdef"}
      conn = delete(conn, Routes.manage_project_admin_join_path(conn, :delete, "blah"), params)

      assert !Projects.is_project_admin?(project, user)
      assert redirected_to(conn) == "/abcdef"
    end
  end
end
