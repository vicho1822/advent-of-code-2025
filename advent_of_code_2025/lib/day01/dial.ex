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
        loop(new_mark, counter + l_clicked_zero(mark, n))

      {:R, n, _from} ->
        new_mark = overflows(mark, n)
        loop(new_mark, counter + r_clicked_zero(mark, n))

      {:EOF, from} ->
        send(from, {:counter, counter})
        loop(50, 0)
    end
  end

  defp overflows(mark, num) do
    (mark + num) |> rem(100)
  end

  defp underflows(mark, num) do
    (mark - (num |> rem(100)) + 100) |> rem(100)
  end

  defp l_clicked_zero(mark, num) do
    hundreds = trunc(num / 100)
    aux = rem(num, 100)

    extra_click = cond do
      aux == 0 -> 0
      mark == 0 and aux <= 99 -> 0
      aux >= mark -> 1
      true -> 0
    end

    hundreds + extra_click
  end

  defp r_clicked_zero(mark, num) do
    hundreds = trunc(num / 100)
    aux = rem(num, 100)
    case (mark + aux) >= 100 do
      true -> hundreds + 1
      false -> hundreds
    end
  end
end
