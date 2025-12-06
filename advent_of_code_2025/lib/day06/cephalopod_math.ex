defmodule Cephalopod_math do
  @moduledoc"""

  """
  @operations ["*", "+"]

  def ceph_solve(input) do
    {op, nums} = parse_in_ceph_sintax(input)
    operate(nums, op)
    |> Enum.sum()
  end

  def solve_problem(input) do
    parse(input)
    |> calc()
    |> Enum.sum()
  end

  defp parse_in_ceph_sintax(input) do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn str ->
      String.split(str, "", trim: true)
    end)
    |> tupling_numbers()
  end

  defp tupling_numbers(mtx) do
    operators = Enum.at(mtx, length(mtx) - 1)
    |> Enum.reject(fn elem -> elem == " " end)

    nums_lists = Enum.reject(mtx, fn lst ->
      Enum.at(lst, 0) in @operations
    end)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn lst ->
      get_digits(lst)
    end)

    {operators, nums_lists}
  end

  defp get_digits(lst) do
    indexed = Enum.map(lst, fn num ->
      case num == " " do
        true -> []
        false -> String.to_integer(num)
      end
    end)
    |> Enum.reject(fn empty -> empty == [] end)
    |> Enum.with_index()

    Enum.map(indexed, fn {num, pos} ->
      potency = length(indexed) - 1 - pos
      num * :math.pow(10, potency)
    end)
    |> Enum.sum()
  end

  defp operate(nums, ops), do: operate(nums, ops, [], 0)

  defp operate([], _op, res, acc), do: [acc | res]

  defp operate([0 | nums], [_op | operations], res, acc), do: operate(nums, operations, [acc | res], 0)

  defp operate([n | nums], [op | operations], res, acc) do
    # case n == 0 do
    #   true -> operate(nums, operations, [acc | res], 1)
    #   false ->
        cond do
          op == Enum.at(@operations, 0) ->
            case acc == 0 do
              true -> operate(nums, [op | operations], res, n)
              false -> operate(nums, [op | operations], res, acc * n)
            end
          op == Enum.at(@operations, 1) -> operate(nums, [op | operations], res, acc + n)
        end
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
