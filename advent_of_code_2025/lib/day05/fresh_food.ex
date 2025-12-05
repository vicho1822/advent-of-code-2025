defmodule Fresh_food do
  @moduledoc"""

  """

  def get_fresh(input) do
    File.read!(input)
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn str -> String.split(str, "\n", trim: true) end)
    |> get_ranges()
    |> check_fresh()
    |> length()
  end

  defp get_ranges(mtx) do
    ranges = Enum.at(mtx, 0)
    |> Enum.map(fn str ->
      case String.split(str, "-") |> Enum.map(&String.to_integer/1) do
        [a, b] -> {a, b}
      end
    end)

    ingredients = Enum.at(mtx, 1)
    |> Enum.map(&String.to_integer/1)

    [ranges, ingredients]
  end

  defp check_fresh(mtx) do
    check_fresh(Enum.at(mtx, 0), Enum.at(mtx, 1), [])
  end

  defp check_fresh([], _ing, fresh), do: fresh

  defp check_fresh([rang | ranges], ingredients, fresh) do
    {new_fresh, sail} = are_fresh?(rang, ingredients, fresh, [])
    check_fresh(ranges, sail, new_fresh)
  end

  defp are_fresh?(_range, [], fresh, sail), do: {fresh, sail}

  defp are_fresh?({lrange, brange}, [ing | ingredients], fresh, sail) do
    case lrange <= ing and ing <= brange do
      true -> are_fresh?({lrange, brange}, ingredients, [ing | fresh], sail)
      false -> are_fresh?({lrange, brange}, ingredients, fresh, [ing | sail])
    end
  end
end
