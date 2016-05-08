defmodule HebrewTranscoderTest do
  use ExUnit.Case
  doctest HebrewTranscoder

  test "crosswalk.json exists" do
    assert File.exists? "data/crosswalk.json"
  end
  test "fn `bwheb_to_map` returns Char for each bwheb character" do
    input = "b"
    expected = "ב"
    test = HebrewTranscoder.bwheb_to_map(input)

    assert Map.fetch!(test, :hebrew) == expected
  end
  test "fn `syllabify` returns syllabified word" do
    input = "yl;xª.a;"
    expected = "אַחְ֗לַי"
    test = HebrewTranscoder.syllabify(input)

    assert test == expected
  end

end
