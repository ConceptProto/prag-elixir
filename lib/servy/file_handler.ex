defmodule Servy.FileHandler do
  alias Servy.Conv

  def handle_file({:ok, content}, %Conv{} = conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, %Conv{} = conv) do
    %{conv | status: 404, resp_body: "File not found"}
  end

  def handle_file({:error, reason}, %Conv{} = conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end

  def handle_file({:ok, content}, %Conv{} = conv, "markdown") do
    Earmark.as_html(content)
    |> to_html(conv)
  end

  defp to_html({:ok, html_doc, _}, %Conv{} = conv) do
    %{conv | status: 200, resp_body: html_doc}
  end

  defp to_html({:error, _html_doc, reason}, %Conv{} = conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end
end
