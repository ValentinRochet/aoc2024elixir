defmodule Day7 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day7-input") do
    input = File.read!(file)

    input
    |> String.split("\r\n")
    |> Enum.map(&parse_line/1)
    |> Enum.filter(fn {result, numbers} ->
      [start | rest] = numbers
      can_combine?(start, rest, result)
    end)
    |> Enum.map(fn {result, _numbers} -> String.to_integer(result) end)
    |> Enum.sum()
  end

  defp parse_line(line) do
    [result, numbers] = String.split(line, ": ", parts: 2)
    result = String.to_integer(result)
    numbers = numbers |> String.split(" ") |> Enum.map(&String.to_integer/1)
    {result, numbers}
  end

  defp can_combine?(current_total, values, expected_result) do
    if length(values) == 0 do
      current_total == expected_result
    else
      [next | rest] = values

      can_combine?(current_total + next, rest, expected_result) or
        can_combine?(current_total * next, rest, expected_result)
    end
  end

  def part1_optimized_by_claude(file \\ "input/day7-input") do
    file
    |> File.read!()
    |> String.split("\r\n", trim: true)
    |> Stream.map(&parse_line/1)
    |> Stream.filter(fn {result, [start | rest]} ->
      can_combine_optimized?(start, rest, result)
    end)
    |> Stream.map(fn {result, _numbers} -> result end)
    |> Enum.sum()
  end

  defp can_combine_optimized?(current, [], expected), do: current == expected

  defp can_combine_optimized?(current, _, expected) when current > expected, do: false

  defp can_combine_optimized?(current, [next | rest], expected) do
    can_combine_optimized?(current + next, rest, expected) or
      can_combine_optimized?(current * next, rest, expected)
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/7-input") do
    _input = File.read!(file)
  end
end
