defmodule Paper_access do
  @moduledoc"""

  """

  @adjacent [
    {-1, 0},
    {-1, 1},
    {-1, -1},
    {1, 0},
    {1, 1},
    {1, -1},
    {0, -1},
    {0, 1},
  ]

  def get_accessible(input) do
    mtx = parse_input(input)
    Enum.with_index(mtx)
    |> Enum.map(fn {row, posy} ->
      Enum.with_index(row)
      |> Enum.map(fn {element, posx} ->
        case element == "@" do
          true -> accessible?(mtx, {posx, posy})
          false -> element
        end
      end)
    end)
    |> Enum.map(fn row -> Enum.count(row, fn element -> element == "x" end) end)
    |> Enum.sum()
  end

  defp parse_input(input) do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  defp accessible?(mtx, pos) do
    case analize_adjacent(mtx, pos, @adjacent, 0) < 4 do
      true -> "x"
      false -> "@"
    end
  end

  defp analize_adjacent(_mtx, _pos, [], sum), do: sum

  defp analize_adjacent(mtx, {x, y}, [{dx, dy} | adjacents], sum) do
    max_x = length(Enum.at(mtx, 0)) - 1
    max_y = length(mtx) - 1
    nx = x + dx
    ny = y + dy

    case nx >= 0 and ny >= 0 and nx <= max_x and ny <= max_y do
      true ->
        neightbor = mtx |> Enum.at(ny) |> Enum.at(nx)
        case (neightbor) == "@" do
          true -> analize_adjacent(mtx, {x, y}, adjacents, sum + 1)
          false -> analize_adjacent(mtx, {x, y}, adjacents, sum)
        end
      false -> analize_adjacent(mtx, {x, y}, adjacents, sum)
    end
  end
end
