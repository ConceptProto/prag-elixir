require Logger

defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    params = parse_params(%Conv{method: "POST"}, request)

    case Enum.empty?(params) do
      true ->
        Logger.error("POST method has no params")

      false ->
        %Conv{method: method, path: path, params: params}
    end
  end

  defp parse_params(_method, request) do
    request
    |> String.split("\n")
    |> Enum.at(-2)
    |> URI.decode_query()
  end
end
