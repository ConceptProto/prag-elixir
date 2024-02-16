defmodule Servy.View do
  @templates_path Path.expand("../templates", "__DIR__")

  def render(items, template, conv) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(assigns: items)

    %{conv | status: 200, resp_body: content}
  end
end
