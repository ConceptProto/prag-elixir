defmodule Servy.BearsController do
  alias Servy.Wildthings

  import Servy.View, only: [render: 3]

  def index(conv) do
    Wildthings.list_bears() |> render("index.eex", conv)
  end

  def show(conv, %{"id" => id}) do
    Wildthings.get_bear(id) |> render("show.eex", conv)
  end

  def create(conv, %{"type" => type, "name" => name}) do
    %{
      conv
      | status: 201,
        resp_body: "Created a #{type} bear named #{name}!"
    }
  end

  def delete(conv, _params) do
    %{conv | status: 403, resp_body: "Deleting a bear is forbidden!"}
  end
end
