defmodule Input_parser do
  @moduledoc"""

  """

  def parse_input(input, pid) do
    {:ok, content} = File.read(input)
    ids = String.split(content, ",")
    sep_ids = separate_ids(ids)

    send(pid, {sep_ids, self()})

    receive do
      {:invalid_sum, s_ids} -> s_ids
    end
  end

  defp separate_ids(ids), do: separate_ids(ids, [])
  defp separate_ids([], sep_ids), do: sep_ids
  defp separate_ids([id | rest], sep_ids) do
    case String.split(id, "-") do
      [id1, id2] ->
        {i1, _} = Integer.parse(id1)
        {i2, _} = Integer.parse(id2)
        separate_ids(rest, [{i1, i2} | sep_ids])
      _ -> {:error, :bad_format}
    end
  end
end
