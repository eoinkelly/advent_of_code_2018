defmodule Mix.Tasks.Day1 do
  use Mix.Task

  # relative to mix project root
  @input_path "inputs/day_1.txt"

  @shortdoc "Day 1"
  def run(_) do
    # Puzzle 1
    frequencies()
    |> Enum.sum()
    |> IO.inspect(label: "Puzzle 1 Answer")

    # Puzzle 2
    Stream.cycle(frequencies())
    |> Stream.scan(&(&1 + &2))
    |> Stream.transform([], fn freq, acc ->
      if Enum.member?(acc, freq) do
        {:halt, acc}
      else
        {[freq], [freq | acc]}
      end
    end)
    |> Stream.take(-1)
    |> Enum.to_list()
    |> List.first()
    |> IO.inspect(label: "Puzzle 2 Answer")
  end

  defp frequencies do
    {:ok, data} = File.read(input_path())

    data
    |> String.split("\n", trim: true)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(fn {i, _rem} -> i end)
  end

  defp input_path do
    {:ok, cwd} = File.cwd()
    Path.absname(@input_path, cwd)
  end
end
