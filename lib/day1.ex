defmodule Day1 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day1-input") do
    input = File.read!(file)

    leftPart =
      input
      |> String.split("\r\n")
      |> Enum.map(fn line -> line |> String.split("   ") |> List.first() end)
      |> Enum.sort()

    rightPart =
      input
      |> String.split("\r\n")
      |> Enum.map(fn line -> line |> String.split("   ") |> List.last() end)
      |> Enum.sort()

    total =
      Enum.zip_with(leftPart, rightPart, fn left, right ->
        abs(String.to_integer(left) - String.to_integer(right))
      end)
      |> Enum.sum()

    total
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day1-input") do
    input = File.read!(file)

    leftPart =
      input
      |> String.split("\r\n")
      |> Enum.map(fn line -> line |> String.split("   ") |> List.first() end)
      |> Enum.sort()

    rightPart =
      input
      |> String.split("\r\n")
      |> Enum.map(fn line -> line |> String.split("   ") |> List.last() end)
      |> Enum.sort()

    total =
      Enum.map(leftPart, fn l ->
        String.to_integer(l) * Enum.count(rightPart, fn r -> r == l end)
      end)
      |> Enum.sum()

    total
  end

  def part2OptimizedByClaude(file \\ "input/day1-input") do
    input = File.read!(file)

    leftPart =
      input
      |> String.split("\r\n")
      |> Enum.map(fn line -> line |> String.split("   ") |> List.first() end)

    rightFreq =
      input
      |> String.split("\r\n")
      |> Enum.map(fn line -> line |> String.split("   ") |> List.last() end)
      |> Enum.frequencies()

    leftPart
    |> Enum.map(fn l ->
      String.to_integer(l) * Map.get(rightFreq, l, 0)
    end)
    |> Enum.sum()
  end
end
