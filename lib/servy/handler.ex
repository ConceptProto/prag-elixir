require Logger

defmodule Servy.Handler do
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

  def track(%{status: 404, path: path} = conv) do
    IO.puts("Warning: #{path} is on the loose!")
    conv
  end

  def track(conv), do: conv

  def log(conv), do: IO.inspect(conv)

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, status: nil, resp_body: ""}
  end

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%{path: path} = conv) do
    uri = URI.parse(path)
    params = URI.decode_query(uri.query || "")

    IO.inspect(params)

    if params["id"] do
      pathname = uri.path <> "/" <> params["id"]
      %{conv | path: pathname}
    else
      conv
    end
  end

  def rewrite_path(conv), do: conv

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(%{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end

  def route(%{method: "GET", path: "/goats/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Goat #{id}"}
  end

  def route(%{method: "DELETE", path: "/bears/" <> _id} = conv) do
    %{conv | status: 403, resp_body: "Deleting a bear is forbidden!"}
  end

  def route(%{path: path} = conv) do
    Logger.error("Please check the url")
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end

  def emojify(%{status: 200, resp_body: resp_body} = conv) do
    %{conv | resp_body: "🎉🎉🎉🎉🎉\n\n" <> resp_body <> "\n\n🎉🎉🎉🎉🎉"}
  end

  def emojify(conv), do: conv

  def format_response(conv) do
    """
    HTTPS/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv[:resp_body]}
    """
  end
end

# request = """
# GET /wildthings HTTP/1.1
# HOST: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

# request = """
# GET /bigfoot HTTP/1.1
# HOST: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# expected_response = """
# HTTPS/1.1 200 OK
# Content-Type: text/html
# Content-Length: 20

# Bears, Lions, Tigers
# """

response = Servy.Handler.handle(request)
# IO.inspect(response)
IO.puts(response)

# conv = %{method: "GET", path: "/wildthings", resp_body: "Bears, Lions, Tigers"}

# [bears, lions, tigers] = conv.resp_body |> String.split(" ")
