defmodule Mix.Tasks.Day2 do
  use Mix.Task

  # relative to mix project root
  @input_path "inputs/day_2.txt"

  @shortdoc "Day 2"
  def run(_) do
    # Puzzle 1
    {total_num_double_repeats_seen, total_num_triple_repeats_seen} =
      checksums()
      |> Enum.reduce({0, 0}, fn checksum, {num_double_repeats_seen, num_triple_repeats_seen} ->
        # iex(8)> "hellothisisatest" |> String.graphemes() |> Enum.sort() |> Enum.chunk_by(&(&1))
        # [
        #   ["a"],
        #   ["e", "e"],
        #   ["h", "h"],
        #   ["i", "i"],
        #   ["l", "l"],
        #   ["o"],
        #   ["s", "s", "s"],
        #   ["t", "t", "t"]
        # ]
        all_repeats =
          checksum
          |> String.graphemes()
          |> Enum.sort()
          |> Enum.chunk_by(& &1)

        contains_double_repeat = all_repeats |> Enum.any?(&(length(&1) == 2))

        contains_triple_repeat = all_repeats |> Enum.any?(&(length(&1) == 3))

        case {contains_double_repeat, contains_triple_repeat} do
          {false, false} -> {num_double_repeats_seen, num_triple_repeats_seen}
          {true, false} -> {num_double_repeats_seen + 1, num_triple_repeats_seen}
          {false, true} -> {num_double_repeats_seen, num_triple_repeats_seen + 1}
          {true, true} -> {num_double_repeats_seen + 1, num_triple_repeats_seen + 1}
        end
      end)

    answer = total_num_double_repeats_seen * total_num_triple_repeats_seen
    IO.inspect(answer, label: "Puzzle 1 Answer")

    # Puzzle 2
    Enum.reduce_while(checksums(), nil, fn checksum_i, _acc ->
      case Enum.find(checksums(), &differs_by_single_char?(checksum_i, &1)) do
        nil -> {:cont, nil}
        checksum_j -> {:halt, {checksum_i, checksum_j}}
      end
    end)
    |> only_chars_in_common()
    |> IO.inspect(label: "Puzzle 2 Answer")
  end

  defp differs_by_single_char?(a, b) do
    Simetric.Levenshtein.compare(a, b) == 1
  end

  defp only_chars_in_common({a, b}) do
    a_chars = String.graphemes(a)
    b_chars = String.graphemes(b)

    diff = a_chars -- b_chars
    intersection = a_chars -- diff

    Enum.join(intersection)
  end

  defp checksums do
    {:ok, data} = File.read(input_path())

    data |> String.split("\n", trim: true)
  end

  defp input_path do
    {:ok, cwd} = File.cwd()
    Path.absname(@input_path, cwd)
  end
end
