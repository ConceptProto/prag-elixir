defmodule Servy.BearsController do
  alias Servy.Wildthings
  alias Servy.Bear

  def index(conv) do
    bear_items =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_asc_by_name/2)
      |> Enum.map(&bear_item/1)
      |> List.to_string()

    %{conv | status: 200, resp_body: "<ul>#{bear_items}</ul>"}
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    %{conv | status: 200, resp_body: "<h1>#{bear.id} - #{bear.name}</h1>"}
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

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end
end
