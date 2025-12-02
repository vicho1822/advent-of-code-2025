defmodule IdentifierChecker do
  @moduledoc """

  """

  def init() do
    spawn(fn -> loop() end)
  end

  defp loop() do
    receive do
      {ids, from} ->
        ill = check_ids(ids)
        sum = ill |> List.flatten() |> Enum.sum()
        send(from, {:invalid_sum, sum})
    end
  end

  defp check_ids(lst), do: check_ids(lst, [])
  defp check_ids([], illegal), do: illegal
  defp check_ids([{i1, i2} | rest], illegal) do
    case check_interval(i1, i2) do
      [] -> check_ids(rest, illegal)
      ill -> check_ids(rest, [ill | illegal])
    end
  end

  defp check_interval(n1, n2) do
    IO.puts("Checking #{n1} - #{n2}")
    Enum.filter(n1..n2, fn n -> repeated?(n) end)
  end

  defp repeated?(num) do
    {l_part, r_part} = num |> to_string() |> split_string_in_half()
    if l_part == r_part do
      true
    else
      false
    end
  end

  defp split_string_in_half(str) do
    len = String.length(str)
    spl = div(len, 2)
    {l_part, r_part} = str |> String.split_at(spl)
  end
end
