require Logger

defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [method, path, _protocol] =
      request
      |> String.split("\r\n")
      |> List.first()
      |> String.split(" ")

    # IO.inspect(method, label: "method - 🚧")
    # IO.inspect(path, label: "path - 🚧")

    headers = parse_headers(request)
    # |> IO.inspect(label: "headers - 🚧")

    params = parse_params(method, headers, request)
    # |> IO.inspect(label: "params - 🚧")

    error = if(params == %{}, do: "POST method has no params")

    %Conv{
      method: method,
      path: path,
      params: params,
      error: error,
      headers: headers
    }
  end

  def parse_params("POST", %{"Content-Type" => content_type}, request)
      when content_type == "application/X-www-form-urlencoded" do
    request
    |> String.split("\r\n")
    |> Enum.at(-2)
    |> URI.decode_query()
  end

  def parse_params(_method, _headers, _request), do: %{}

  def parse_headers(request) do
    request
    |> String.split("\r\n")
    |> Enum.slice(1..5)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn x ->
      [key, value] = String.split(x, ": ")
      %{key => value}
    end)
    |> Enum.reduce(%{}, fn x, acc ->
      %{}
      Map.merge(x, acc)
    end)
  end
end
