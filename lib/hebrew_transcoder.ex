defmodule HebrewTranscoder do

  def get_crosswalk do
    input = File.read! "data/crosswalk.json"
    Poison.decode!(input, as: [%Char{}])
  end

  def bwheb_to_map(bwheb) do
    get_crosswalk
    |> Enum.filter(fn(char)-> Map.fetch!(char, :bwheb) == bwheb end)
    |> Enum.fetch!(0)
  end

  def syllabify(word) do
    String.split(word, "", trim: true)
    |> Enum.map(fn(bwheb)-> HebrewTranscoder.bwheb_to_map(bwheb) end)
    |> Enum.reduce([],
      fn(char, acc)->
        if Regex.match?(~r/cons/, Map.fetch!(char, :char_type)) do
          [[char] | acc]
        else
          [head | tail] = acc
          syllable = [char | head]
          List.replace_at(acc, 0, syllable)
        end
      end)
    |> Enum.map(
      fn(syl)-> Enum.sort(syl, fn(a, b)->
          order = ["cons", "vow", "cant"]
          index_a = Enum.find_index(order, fn(x)-> x == a.char_type end)
          index_b = Enum.find_index(order, fn(x)-> x == b.char_type end)
          index_a < index_b
        end)
      end)
    |> List.flatten()
    |> Enum.map(fn(char)-> char.hebrew end)
    |> Enum.join()
  end
end
