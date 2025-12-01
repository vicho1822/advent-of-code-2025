defmodule Dial do
  @moduledoc"""

  """

  def init_() do
    spawn(fn -> loop(50) end)
  end

  defp loop(mark), do: loop(mark, 0)
  defp loop(mark, counter) do
    receive do
      {:L, n, _from} ->
        new_mark = underflows(mark, n)
        IO.puts("L #{n} #{new_mark}")
        loop(new_mark, if(new_mark == 0, do: counter + 1, else: counter))
      {:R, n, _from} ->
        new_mark = overflows(mark, n)
        IO.puts("R #{n} #{new_mark}")
        loop(new_mark, if(new_mark == 0, do: counter + 1, else: counter))
      {:EOF, from} ->
        send(from, {:counter, counter})
        loop(50, 0)
    end
  end

  defp overflows(mark, num) do
    h = get_hundreds(num, 0)
    dec = num - h * 100
    aux = mark + dec
    cond do
      aux > 99 -> aux - 100
      true -> aux
    end
  end

  defp underflows(mark, num) do
    h = get_hundreds(num, 0)
    dec = num - h * 100
    aux = mark - dec
    cond do
      aux < 0 -> aux + 100
      true -> aux
    end
  end

  defp get_hundreds(num, h) do
    aux = num - 100
    cond do
      aux > 0 -> get_hundreds(aux, h+1)
      aux == 0 -> h + 1
      aux < 0 -> h
    end
  end
end
