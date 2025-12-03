defmodule Day01.Input_parser do
  @moduledoc"""

  """

  def parse_input(input, pid) do
    File.stream!(input)
    |> Enum.each(fn line ->
      clean = String.trim(line)
      read_rotation(clean, pid)
    end)

    send(pid, {:EOF, self()})

    receive do
      {:counter, zeros} -> zeros
    end
  end

  defp read_rotation("L" <> rest, pid) do
    {num, _} = Integer.parse(rest)
    send(pid, {:L, num, self()})
  end

  defp read_rotation("R" <> rest, pid) do
    {num, _} = Integer.parse(rest)
    send(pid, {:R, num, self()})
  end
end
