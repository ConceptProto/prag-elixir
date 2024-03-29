defmodule HandlerTest do
  use ExUnit.Case, async: true

  import Servy.Handler, only: [handle: 1]

  test "GET /api/bears" do
    request = """
    GET /api/bears HTTPS/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTPS/1.1 200 OK\r
    Content-Type: application/json\r
    Content-Length: 605\r
    \r
    [{"hibernating": true, "type": "Brown", "name": "Teddy", "id": 1},
      {"hibernating": false, "type": "Black", "name": "Smokey", "id": 2},
      {"hibernating": false, "type": "Brown", "name": "Paddington", "id": 3},
      {"hibernating": true, "type": "Grizzly", "name": "Scarface", "id": 4},
      {"hibernating": false, "type": "Polar", "name": "Snow", "id": 5},
      {"hibernating": false, "type": "Grizzly", "name": "Brutus", "id": 6},
      {"hibernating": true, "type": "Black", "name": "Rosie", "id": 7},
      {"hibernating": false, "type": "Panda", "name": "Roscoe", "id": 8},
      {"hibernating": true, "type": "Polar", "name": "Iceman", "id": 9},
      {"hibernating": false, "type": "Grizzly", "name": "Kenai", "id": 10}]
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /api/bears" do
    request = """
    POST /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/json\r
    Content-Length: 21\r
    \r
    {"name": "Breezly", "type": "Polar"}
    """

    response = handle(request)

    expected_response = """
      HTTPS/1.1 201 Created\r
      Content-Type: text/html\r
      Content-Length: 43\r
      \r
      🎉Created a Polar bear named Breezly!🎉\r
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

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
    Content-Length: 660\r
    \r
    🎉<h1>\nFrequently Asked Questions</h1>\n<ul>\n  <li>\n    <p>\n<strong>Have you really seen Bigfoot?</strong>    </p>\n    <p>\nYes! In this <a href=\"https://www.youtube.com/watch?v=ZMBeN4Kr4LE\">totally believable video</a>!    </p>\n  </li>\n  <li>\n    <p>\n<strong>No, I mean seen Bigfoot <em>on the refuge</em>?</strong>    </p>\n    <p>\nOh! Not yet, but we’re <em>still looking</em>…    </p>\n  </li>\n  <li>\n    <p>\n<strong>Can you just show me some code?</strong>    </p>\n    <p>\nSure! Here’s some Elixir:    </p>\n    <pre><code class=\"elixir\">[&quot;Bigfoot&quot;, &quot;Yeti&quot;, &quot;Sasquatch&quot;] |&gt; Enum.random()</code></pre>\n  </li>\n</ul>\n🎉
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
