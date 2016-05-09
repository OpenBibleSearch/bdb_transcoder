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
          # Matches that contain `cons` in their `char_type` are
          # given a new sub-list at the head of the main list
          # additional vowels, etc. will be added to the sub-list
          [[char] | acc]
        else
          # Reassigns the head of the list (i.e. the most recent syllable,
          # see above) to `head` and prepends the new char to the syllable.
          # Finally, it replaces the old head of the list with the new one
          [head | tail] = acc
          syllable = [char | head]
          List.replace_at(acc, 0, syllable)
        end
      end)
    |> Enum.map(
      # Sorts each syllable by a consistent encoding order following
      # the basic pattern:
      #   1) Consonant
      #   2) Dagesh [Encoded in the map]
      #   3) Vowels
      #   4) Cantilation Marks
      #   5) everything else
      fn(syl)-> Enum.sort(syl, fn(a, b)->
          order = [
            "cons",
            "cons+dag",
            "cons+vow",
            "vow",
            "cant",
            "roman",
            "other"
          ]
          index_a = Enum.find_index(order, fn(x)-> x == a.char_type end)
          index_b = Enum.find_index(order, fn(x)-> x == b.char_type end)

          index_a < index_b
        end)
      end)
    |> List.flatten()
    |> Enum.map(fn(char)-> char.hebrew end)
    |> Enum.join()
  end
  def split_words(string) do
    String.split(string, " ")
  end
  def transcode(match) do
    match
    |> split_words()
    |> Enum.map(&syllabify/1)
    |> Enum.reverse()
    |> Enum.join(" ")
  end
end
