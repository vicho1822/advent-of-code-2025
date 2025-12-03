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
        {f, l} = get_bank_joltage(lst)
        num = f * 10 + l
        loop(sum + num)
      {:EOF, from} ->
        send(from, {:joltage, sum})
        loop(0)
      {:stop, from} ->
        send(from, :stopped)
    end
  end

  defp get_bank_joltage(lst), do: get_bank_joltage(lst, -1, -1)
  defp get_bank_joltage([num], fnum, lnum) do
    case num > lnum do
      true -> {fnum, num}
      false -> {fnum, lnum}
    end
  end
  defp get_bank_joltage([num | lst], fnum, lnum) do
    case num > fnum do
      true -> get_bank_joltage(lst, num, -1)
      false ->
        case num > lnum do
          true -> get_bank_joltage(lst, fnum, num)
          false -> get_bank_joltage(lst, fnum, lnum)
        end
    end
  end

end
