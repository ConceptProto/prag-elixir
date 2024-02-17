require Logger

defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests."

  import Servy.Plugins, only: [rewrite_path: 1, track: 1, log: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2]

  alias Servy.Conv
  alias Servy.BearsController

  @pages_path Path.expand("pages", File.cwd!())

  @doc "Trasforms the request into a response."
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> route
    |> track
    |> log
    |> emojify
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearsController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearsController.show(conv, params)
  end

  def route(%Conv{method: "POST", error: "POST method has no params"} = conv) do
    %{
      conv
      | status: 400,
        resp_body: "#{conv.error}"
    }
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearsController.create(conv, conv.params)
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
    # %{conv | status: 403, resp_body: "Deleting a bear is forbidden!"}
    BearsController.delete(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/goats/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Goat #{id}"}
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
    @pages_path
    |> Path.join(file <> ".html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  def emojify(%Conv{status: 200, resp_body: resp_body} = conv) do
    %{conv | resp_body: "🎉" <> resp_body <> "🎉"}
  end

  def emojify(%Conv{status: 201, resp_body: resp_body} = conv) do
    %{conv | resp_body: "🎉" <> resp_body <> "🎉"}
  end

  def emojify(%Conv{status: status, resp_body: resp_body} = conv)
      when status >= 400 and status <= 500 do
    %{conv | resp_body: "🚨" <> resp_body <> "🚨"}
  end

  def emojify(%Conv{} = conv), do: conv

  def format_response(%Conv{} = conv) do
    """
    HTTPS/1.1 #{Conv.full_status(conv)}\r
    Content-Type: text/html\r
    Content-Length: #{byte_size(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end
