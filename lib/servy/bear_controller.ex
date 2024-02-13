defmodule Servy.BearsController do
  alias Servy.Wildthings

  def index(conv) do
    bears = Wildthings.list_bears()

    names = Enum.map(bears, fn bear -> "<li>#{bear.name}</li>" end)

    html_names = List.to_string(names)

    %{conv | status: 200, resp_body: "<ul>#{html_names}</ul>"}
  end

  def show(conv, %{"id" => id}) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end

  def create(conv, %{"type" => type, "name" => name}) do
    %{
      conv
      | status: 201,
        resp_body: "Created a #{type} bear named #{name}!"
    }
  end
end
