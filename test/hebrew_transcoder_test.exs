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
  test "fn `split_words` splits string on space'" do
    input = ~s(aY"m;v.Bi Hl'a/ yt;yai)
    expected = ["aY\"m;v.Bi", "Hl'a/", "yt;yai"]

    test = HebrewTranscoder.split_words(input)

    assert test == expected
  end
  test "fn `transcode` Splits, transcodes, and reassembles Hebrew phrases" do
    input = ~s(aY"m;v.Bi Hl'a/ yt;yai)
    expected = "אִיתַי אֱלָהּ בִּשְׁמַיָּא"

    test = HebrewTranscoder.transcode(input)

    assert test == expected
  end
end
