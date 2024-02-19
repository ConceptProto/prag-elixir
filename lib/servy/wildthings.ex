defmodule Servy.Wildthings do
  alias Servy.Bear

  def list_bears do
    %{"bears" => bears} =
      Path.expand("../../db", __DIR__)
      |> Path.join("bears.json")
      |> read_json
      |> decode_json

    bears
  end

  def get_bear(id) when is_integer(id) do
    list_bears()
    |> Enum.find(fn bear -> bear.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    list_bears()
    |> Enum.find(fn bear -> bear.id == String.to_integer(id) end)
  end

  defp read_json(path) do
    case File.read(path) do
      {:ok, file} ->
        file

      {:error, reason} ->
        IO.puts("Error reading #{path}: #{reason}")
        "[]"
    end
  end

  defp decode_json(file) do
    try do
      Poison.decode!(file, as: %{"bears" => [%Bear{}]})
    rescue
      exception ->
        IO.puts("Error decoding #{file}: #{exception.message}")
        nil
    end
  end
end

# Poison.decode!("{"bears": [{"id": 1,"name": "Teddy","type": "Brown","hibernating": true}]}", as: %{"bears" => [%Bear{}]})
