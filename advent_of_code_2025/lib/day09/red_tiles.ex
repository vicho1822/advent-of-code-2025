defmodule RedTiles do
  @moduledoc """

  """

  def biggest_rectangle(input) do
    parse(input)
    |> get_biggest()
  end

  defp parse(input) do
    File.read!(input)
    |> String.split("\n")
    |> Enum.map(fn str ->
      case String.split(str, ",") do
        [a, b] -> {String.to_integer(a), String.to_integer(b)}
        [_n] -> IO.puts("Error parsing")
      end
    end)
  end

  defp get_area({x1, y1}, {x2, y2}) do
    abs(x1 - x2 + 1) * abs(y1 - y2 + 1)
  end

  defp get_biggest(vectors), do: get_biggest(vectors, 0)

  defp get_biggest([_v], res), do: res

  defp get_biggest([v | vectors], res) do
    new_res = Enum.map(vectors, fn vec ->
      get_area(v, vec)
    end)
    |> Enum.max()
    get_biggest(vectors, if(res > new_res, do: res, else: new_res))
  end
end
