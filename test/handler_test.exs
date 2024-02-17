defmodule HandlerTest do
  use ExUnit.Case, async: true

  import Servy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTPS/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTPS/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 28\r
           \r
           🎉Bears, Lions, Tigers🎉
           """
  end

  test "GET /bears" do
    request = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTPS/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 364\r
    \r
    🎉<h1>All The Bears!</h1>

    <ul>
    <li>Teddy - Brown</li>
    <li>Smokey - Black</li>
    <li>Paddington - Brown</li>
    <li>Scarface - Grizzly</li>
    <li>Snow - Polar</li>
    <li>Brutus - Grizzly</li>
    <li>Rosie - Black</li>
    <li>Roscoe - Panda</li>
    <li>Iceman - Polar</li>
    <li>Kenai - Grizzly</li>
    </ul>
    🎉
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bears/:id" do
    request = """
    GET /bears?id=9 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTPS/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 80\r
    \r
    🎉<h1>Show Bear</h1>\r

    <p>Is Iceman hibernating? <strong>true</strong></p>
    🎉
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bears/new" do
    request = """
    GET /bears/new HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTPS/1.1 200 OK
    Content-Type: text/html\r
    Content-Length: 239\r
    \r
    🎉<form action="/bears" method="POST">
    <p>
    Name:<br/>
    <input type="text" name="name">
    </p>
    <p>
    Type:<br/>
    <input type="text" name="type">
    </p>
    <p>
    <input type="submit" value="Create Bear">
    </p>
    </form>🎉
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /bears without parameters" do
    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/X-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTPS/1.1 400 Bad Request\r
    Content-Type: text/html\r
    Content-Length: 33\r
    \r
    🚨POST method has no params🚨
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /bears" do
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

    response = handle(request)

    expected_response = """
    HTTPS/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 41\r
    \r
    🎉Created a Brown bear named Baloo!🎉\r
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "DELETE /bears?id=5" do
    request = """
    DELETE /bears?id=5 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTPS/1.1 403 Forbidden\r
    Content-Type: text/html\r
    Content-Length: 37\r
    \r
    🚨Deleting a bear is forbidden!🚨
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET incorrect url" do
    request = """
    GET /bigfoot HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTPS/1.1 404 Not Found\r
    Content-Type: text/html\r
    Content-Length: 25\r
    \r
    🚨No /bigfoot here!🚨
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTPS/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 678\r
    \r
    🎉<h1>About Jacques</h1>\r
    \r
    <blockquote>
    I told my wife she should embrace her mistakes. She gave me a hug.
    What do you call fake spaghetti? An "impasta."
    Why don't eggs tell jokes? They'd crack each other up.
    I'm reading a book on anti-gravity. It's impossible to put down!
    What do you call a belt made of watches? A waist of time.
    Why did the scarecrow win an award? Because he was outstanding in his field.
    I would tell you a construction joke, but I'm still working on it.
    How do you organize a space party? You planet.
    What do you call a fish wearing a crown? A king carp.
    Why couldn't the bicycle stand up by itself? It was two-tired.
    </blockquote>🎉
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /pages/contact" do
    request = """
    GET /pages/contact HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTPS/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 29\r
    \r
    🎉<h1>Contact PAGE</h1>🎉
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /pages/faq" do
    request = """
    GET /pages/faq HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTPS/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 25\r
    \r
    🎉<h1>FAQ PAGE</h1>🎉
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
