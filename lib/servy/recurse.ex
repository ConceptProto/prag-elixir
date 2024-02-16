defmodule Servy.Recurse do
  def my_map([head | tail], fun) do
    [fun.(head) | my_map(tail, fun)]
  end

  def my_map([], _fun), do: []
end

nums = [1, 2, 3, 4, 5]
tmp = Servy.Recurse.my_map(nums, &(&1 * 2))
IO.inspect(tmp)
# [2, 4, 6, 8, 10]
