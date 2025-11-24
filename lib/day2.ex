defmodule Day2 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day2-input") do
    input = File.read!(file)

    reports =
      input
      |> String.split("\r\n")
      |> Enum.map(fn line ->
        line
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)
      end)

    reports
    |> Enum.count(fn line ->
      is_safe_increasing?(line) || is_safe_decreasing?(line)
    end)
  end

  defp is_safe_increasing?(report) do
    if length(report) < 2 do
      true
    else
      [first | queue] = report
      second = List.first(queue)

      if(second - first < 1 || second - first > 3) do
        false
      else
        is_safe_increasing?(queue)
      end
    end
  end

  defp is_safe_decreasing?(report) do
    if length(report) < 2 do
      true
    else
      [first | queue] = report
      second = List.first(queue)

      if(first - second < 1 || first - second > 3) do
        false
      else
        is_safe_decreasing?(queue)
      end
    end
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day2-input") do
    input = File.read!(file)

    reports =
      input
      |> String.split("\r\n")
      |> Enum.map(fn line ->
        line
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)
      end)

    reports
    |> Enum.count(fn line ->
      is_safe_increasing?(line) ||
        is_safe_decreasing?(line) ||
        is_safe_with_dampener?(line)
    end)
  end

  defp is_safe_with_dampener?(report) do
    count =
      remove_each(report)
      |> Enum.filter(fn line ->
        is_safe_increasing?(line) ||
          is_safe_decreasing?(line)
      end)
      |> Enum.count()

    count > 0
  end

  def remove_each(list) do
    for i <- 0..(length(list) - 1) do
      List.delete_at(list, i)
    end
  end
end
