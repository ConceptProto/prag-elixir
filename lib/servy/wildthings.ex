defmodule Servy.Wildthings do
  alias Servy.Bear

  # def list_bears do
  #   [
  #     %Bear{id: 2, name: "Smokey", type: "Black", hibernating: false},
  #     %Bear{id: 3, name: "Paddington", type: "Brown", hibernating: false},
  #     %Bear{id: 4, name: "Scarface", type: "Grizzly", hibernating: true},
  #     %Bear{id: 5, name: "Snow", type: "Polar", hibernating: false},
  #     %Bear{id: 6, name: "Brutus", type: "Grizzly", hibernating: false},
  #     %Bear{id: 7, name: "Rosie", type: "Black", hibernating: true},
  #     %Bear{id: 1, name: "Teddy", type: "Brown", hibernating: true},
  #     %Bear{id: 8, name: "Roscoe", type: "Panda", hibernating: false},
  #     %Bear{id: 9, name: "Iceman", type: "Polar", hibernating: true},
  #     %Bear{id: 10, name: "Kenai", type: "Grizzly", hibernating: false}
  #   ]
  # end

  def list_bears do
    path = Path.expand("../../db", __DIR__)
    # file = Path.join()
    # TODO: some more things here

    file = Code.eval_file("bears.json", path)
    json = Poison.decode!(file, as: %{"bears" => [%Bear{}]})
    IO.inspect(json, label: "list_bears json 🚧")
  end

  # TODO: Seems like I need to read the json as well

  def get_bear(id) when is_integer(id) do
    list_bears()
    |> Enum.find(fn bear -> bear.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    list_bears()
    |> Enum.find(fn bear -> bear.id == String.to_integer(id) end)
  end
end

# Poison.decode!("{"bears": [{"id": 1,"name": "Teddy","type": "Brown","hibernating": true}]}", as: %{"bears" => [%Bear{}]})
