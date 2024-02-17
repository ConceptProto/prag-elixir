defmodule ParserTest do
  use ExUnit.Case, async: true
  doctest Servy.Parser

  alias Servy.Parser

  test "parsers the request into a map of the headers" do
    request = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Another_header: A\r
    \r
    """

    headers = Parser.parse_headers(request)

    assert headers == %{
             "Host" => "example.com",
             "User-Agent" => "ExampleBrowser/1.0",
             "Accept" => "*/*",
             "Another_header" => "A"
           }
  end

  test "parsers application/X-www-form-urlencoded request into a map of the parameters" do
    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/X-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Baloo&type=Brown\r
    """

    headers = %{"Content-Type" => "application/X-www-form-urlencoded"}

    parameters = Parser.parse_params("POST", headers, request)

    assert parameters == %{
             "name" => "Baloo",
             "type" => "Brown"
           }
  end

  test "does not parse multipart/form-data request into a map of the parameters" do
    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: multipart/form-data\r
    Content-Length: 21\r
    \r
    name=Baloo&type=Brown\r
    """

    headers = %{"Content-Type" => "multipart/form-data"}

    parameters = Parser.parse_params("POST", headers, request)

    refute parameters == %{
             "name" => "Baloo",
             "type" => "Brown"
           }
  end
end
