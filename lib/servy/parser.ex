defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    params = parse_params(%Conv{method: "POST"}, request)

    %Conv{method: method, path: path, params: params}
  end

  defp parse_params(_method, request) do
    request
    |> String.split("\n")
    |> Enum.at(-2)
    |> URI.decode_query()
  end
end
