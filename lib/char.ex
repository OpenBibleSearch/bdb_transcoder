defmodule Char do
  @derive [Poison.Encoder]
  defstruct [
    :ascii_translit,
    :bwheb,
    :char_type,
    :hebrew,
    :is_final_form,
    :occurances,
    :translit
  ]
end
