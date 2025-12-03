defmodule Joltage do
  @moduledoc"""

  """

  def init_() do
    spawn(fn -> loop() end)
  end

  def stop_(pid) do
    send(pid, {:stop, self()})
    receive do
      :stopped -> :ok
    end
  end

  defp loop(), do: loop(0)
  defp loop(sum) do
    receive do
      {:bank, lst} ->
        tol = get_bank_joltage(lst, 12)
        num = sum_batt(tol, 0)
        loop(sum + num)
      {:EOF, from} ->
        send(from, {:joltage, sum})
        loop(0)
      {:stop, from} ->
        send(from, :stopped)
    end
  end

  def get_bank_joltage(lst, min_length), do: get_bank_joltage(lst, -1, [], min_length)
  defp get_bank_joltage([], fnum, rest, _min_length), do: [fnum | rest]
  defp get_bank_joltage([num | lst], fnum, rest, min_length) do
    case num > fnum do
      true ->
        cond do
          length(lst) + 1 > min_length ->
            get_bank_joltage(lst, num, [], min_length)
          length(lst) + 1 == min_length ->
            lst   # Si llegamos a tener length + 1 == 12 y num > fnum entonces ya es el número más alto
          true ->
            new_rest = update_rest(num, rest, min_length - 1, length(lst) + 1, min_length)
            get_bank_joltage(lst, fnum, new_rest, min_length)
        end
      false ->
        new_rest = update_rest(num, rest, min_length - 1, length(lst) + 1, min_length)
        get_bank_joltage(lst, fnum, new_rest, min_length)
    end
  end

  defp update_rest(_num, lst, 0, _remaining, _needed), do: lst
  defp update_rest(num, [], _min_length, _remaining, _needed), do: [num]
  defp update_rest(num, [fnum | rest], min_length, remaining, needed) do
      case min_length <= remaining do
        true ->
          case num > fnum do
            true ->
              [num]
            false ->
              [fnum | update_rest(num, rest, min_length - 1, remaining, needed)]
          end
        false ->
          [fnum | update_rest(num, rest, min_length-1, remaining, needed)]
      end
  end

  defp sum_batt([], res), do: res
  defp sum_batt([f | lst], res) do
    n = f * :math.pow(10, length(lst))
    sum_batt(lst, res + n)
  end

end
