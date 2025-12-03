defmodule Day03.Input_parser do
  @moduledoc"""

  """

  def parse_input(input, pid) do
    File.stream!(input)
    |> Enum.each(fn line ->
      clean = String.trim(line)
      send(pid, {:bank, Enum.reverse(to_list(clean))})
    end)

    send(pid, {:EOF, self()})

    receive do
      {:joltage, sum} -> sum
    end
  end

  defp to_list(str), do: to_list(str, [])
  defp to_list("", lst), do: lst
  defp to_list(str, lst) do
    {fst, rest} = String.split_at(str, 1)
    {num, _} = Integer.parse(fst)
    to_list(rest, [num | lst])
  end

end
