defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    # |> log
    |> route

    # |> format_response
  end

  def log(conv), do: IO.inspect(conv)

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: ""}
  end

  def route(conv) do
    route(conv, conv.method, conv.path)

    # conv = %{conv | resp_body: "Bears, Lions, Tigers"}

    # cond do
    #   conv.path === "/wildthings" ->
    #     %{conv | resp_body: "Bears, Lions, Tigers"}

    #   conv.path === "/bears" or conv.path === "/lions" or conv.path === "/tigers" ->
    #     %{conv | resp_body: filter_animals_by(String.replace(conv.path, "/", ""), conv.resp_body)}

    #   true ->
    #     :error
    # end

    # conv.path === "/bears" -> String.replace(conv.path, "/", "") |> filter_animals_by(conv.resp_body)
  end

  def route(conv, "GET", "/wildthings") do
    %{conv | resp_body: "Bears, Lions, Tigers"}
  end

  # def route(conv, "POST", "/wildthings") do
  # end

  def route(conv, "GET", "/bears") do
    %{conv | resp_body: "Teddy, Smokey, Paddington"}
  end

  # def route(conv, "POST", "/bears") do
  # end

  # def filter_animals_by(animal, resp_body) do
  #   log(animal)
  #   log(resp_body)

  #   resp_body
  #   |> String.replace(" ", "")
  #   |> String.downcase()
  #   |> String.split(",")
  #   |> Enum.filter(fn x -> x === animal end)
  #   |> to_string()
  # end

  def format_response(conv) do
    """
    HTTPS/1.1 200 OK
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
HOST: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

# expected_response = """
# HTTPS/1.1 200 OK
# Content-Type: text/html
# Content-Length: 20

# Bears, Lions, Tigers
# """

response = Servy.Handler.handle(request)
IO.inspect(response)

# conv = %{method: "GET", path: "/wildthings", resp_body: "Bears, Lions, Tigers"}

# [bears, lions, tigers] = conv.resp_body |> String.split(" ")
