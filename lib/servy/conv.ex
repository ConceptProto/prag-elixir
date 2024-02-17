defmodule Servy.Conv do
  defstruct method: "",
            path: "",
            status: nil,
            resp_body: "",
            params: "",
            error: "",
            headers: %{},
            resp_headers: %{"Content-Type" => "text/html"}

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      400 => "Bad Request",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end

# ["POST /bears HTTP/1.1", "Host: example.com", "User-Agent: ExampleBrowser/1.0", "Accept: */*", "Content-Type: application/X-www-form-urlencoded", "Content-Length: 21", "", "name=Baloo&type=Brown", ""]
