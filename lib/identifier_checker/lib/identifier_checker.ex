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
        loop()
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
    Enum.filter(n1..n2, fn n -> repeated?(n) end)
  end

  def repeated?(num) do
    str = num |> to_string()
    repeated?(str, "", "", String.length(str))
  end
  defp repeated?("", patron, actual, length) do
    case length == String.length(patron) do
      true -> false
      false ->
        if(length == String.length(patron) + String.length(actual), do: true, else: IO.puts("Error calculating repeating secuences"))
    end
  end
  defp repeated?(str, "", actual, length) do
    {patr, rest} = String.split_at(str, 1)
    repeated?(rest, patr, actual, length)
  end
  defp repeated?(str, patron, actual, length) do
    p_len = String.length(patron)
    {ac, rest} = String.split_at(str, p_len)
    # TODO: Optimize code
    case patron == ac do
      true -> repeated?(rest, patron, actual <> ac, length)
      false ->
        case actual != "" do
          true ->
            {fst, rs} = String.split_at(actual, 1)
            repeated?(rs <> ac <> rest, patron <> fst, "", length)
          false ->
            {fst, rs} = String.split_at(ac, 1)
            repeated?(rs <> rest, patron <> fst, "", length)
        end
    end
  end
end
