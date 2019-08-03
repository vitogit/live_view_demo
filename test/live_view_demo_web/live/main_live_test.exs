defmodule LiveViewDemoWeb.MainLiveTest do
  use LiveViewDemoWeb.ConnCase
  import Phoenix.LiveViewTest

  test "load index page", %{conn: conn} do
    {:ok, view, html} = live(conn, "/")
    assert html =~ "Welcome to Roll & Music Together"
  end

  test "generate room with 36 characters", %{conn: conn} do
    {:ok, view, html} = live(conn, "/")
    assert html =~ ~r/href=\'\/room\/.{36}\'/ 
  end
end

