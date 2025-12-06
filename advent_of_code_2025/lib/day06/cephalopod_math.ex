defmodule Cephalopod_math do
  @moduledoc"""

  """
  @operations ["*", "+"]

  def solve_problem(input) do
    parse(input)
    |> calc()
    |> Enum.sum()
  end

  defp parse(input) do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn str ->
      String.split(str, " ", trim: true)
      |> Enum.map(fn elem ->
        case elem in @operations  do
          true -> elem
          false -> String.to_integer(elem)
        end
      end)
    end)
    # Trasponer por comodidad
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp calc(mtx), do: calc(mtx, [])

  defp calc([], res), do: res

  defp calc([lst | mtx], res) do
    aux_op = Enum.at(lst, length(lst)-1)

    sum =
      Enum.reduce(lst, 1, fn num, acc ->
        cond do
          num in @operations -> acc
          aux_op == Enum.at(@operations, 0) ->
            acc * num
          aux_op == Enum.at(@operations, 1) -> acc + num
        end
      end)
    case aux_op == Enum.at(@operations, 0) do
      true -> calc(mtx, [sum | res])
      false -> calc(mtx, [sum - 1 | res])
    end
  end
end
