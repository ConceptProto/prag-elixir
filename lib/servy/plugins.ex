defmodule Servy.Plugins do
  @doc "Logs 404 requests"
  def track(%{status: 404, path: path} = conv) do
    IO.puts("Warning: #{path} is on the loose!")
    conv
  end

  def track(conv), do: conv

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

  def log(conv), do: IO.inspect(conv)
end
