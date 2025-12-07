defmodule Tachyon do
  @moduledoc"""

  """

  def count_splits(input) do
    {res, num_split} = parse(input)
    |> do_beam()
    num_split
  end

  defp parse(input) do
    File.read!(input)
    |> String.split("\n")
    |> Enum.map(fn str ->
      String.graphemes(str)
    end)
  end

  defp do_beam([str | lst]), do: do_beam(lst, str, {str, 0})

  defp do_beam([], _prev, res), do: res

  defp do_beam([str | lst], prev, {res, acc}) do
    {devided, new_acc} = devide_beam(str, prev, acc)
    do_beam(lst, devided, {[devided | res], new_acc})
  end

  defp devide_beam([chr | strl], prev, acc) do
    devide_beam(chr, strl, prev, prev, acc)
  end

  defp devide_beam(chr, [], _prev_lst, res, acc), do: {[chr | res], acc}

  defp devide_beam(chr, [nc | strl], [plc | prev_lst], [pc | res], acc) do
    cond do
      plc == "|" ->
        cond do
          chr == "^" ->
            new_nc = case nc == "." do
              true -> "|"
              false -> nc
            end
            new_pc = case pc == "." do
              true -> "|"
              false -> pc
            end
            devide_beam(new_nc, strl, prev_lst, [chr, new_pc | res], acc + 1)
          true -> devide_beam(nc, strl, prev_lst, ["|", pc | res], acc)
        end
      plc == "S" -> devide_beam(nc, strl, prev_lst, ["|", pc | res], acc)
      true -> devide_beam(nc, strl, prev_lst, [chr, pc | res], acc)
    end
  end
end
