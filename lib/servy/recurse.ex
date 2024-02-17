defmodule Servy.Recurse do
  def my_map([head | tail], fun) do
    [fun.(head) | my_map(tail, fun)]
  end

  def my_map([], _fun), do: []

  def comprehension_filter do
    prefs = [{"Betty", :dog}, {"Bob", :dog}, {"Becky", :cat}]

    for {name, pet_choice} <- prefs, pet_choice == :dog do
      IO.inspect(name)
    end
  end

  def playing_cards do
    ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
    suits = ["♣", "♦", "♥", "♠"]

    deck = for rank <- ranks, suit <- suits, do: {rank, suit}

    Enum.each(1..52, fn x -> IO.inspect(Enum.random(deck)) end)
  end
end

# Uncomment to run
# nums = [1, 2, 3, 4, 5]
# tmp = Servy.Recurse.my_map(nums, &(&1 * 2))
# IO.inspect(tmp)
# [2, 4, 6, 8, 10]
