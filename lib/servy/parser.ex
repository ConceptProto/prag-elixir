require Logger

defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [method, path, _protocol] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    # params =
    #   parse_params(
    #     %Conv{method: "POST", headers: ["Content-Type": "application/X-www-form-urlencoded"]} =
    #       conv,
    #     request
    #   )

    headers = parse_headers(request)

    params = parse_params(method, headers, request)

    IO.inspect(params, label: "params 👉")

    error = if(params == %{}, do: "POST method has no params")

    %Conv{
      method: method,
      path: path,
      params: params,
      error: error,
      headers: headers
    }
  end

  # defp parse_params(conv.method, conv.headers, request) do
  #   request
  #   |> String.split("\n")
  #   |> Enum.at(-2)
  #   |> URI.decode_query()
  # end

  defp parse_params("POST", %{"Content-Type" => content_type}, request) when content_type == "application/x-www-form-urlencoded" do
    request
    |> String.split("\n")
    |> Enum.at(-2)
    |> URI.decode_query()
  end

  defp parse_params(_method, _headers, _request), do: %{}

    # defp parse_headers(request) do
  #   request
  #   |> String.split("\n")
  #   |> Enum.slice(1..5)
  #   |> Enum.reject(&(&1 == ""))
  #   |> Enum.map(fn x ->
  #     [key, value] = String.split(x, ": ")
  #     %{key => value}
  #   end)
  #   |> Enum.reduce(%{}, fn x, acc ->
  #     %{}
  #     Map.merge(x, acc)
  #   end)
  # end

  defp parse_headers(request) do
    request
    |> String.split("\n")
    |> parse_headers_recursively(%{})
  end

  defp parse_headers_recursively([head | tail], headers) do
    if String.contains?(head, ": ") do
      [key, value] = String.split(head, ": ")
      headers = Map.put(headers, key, value)
      parse_headers_recursively(tail, headers)
    else
      parse_headers_recursively(tail, headers)
    end
  end

  defp parse_headers_recursively([], headers), do: headers
end
