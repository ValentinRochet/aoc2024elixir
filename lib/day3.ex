defmodule Day3 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day3-input") do
    input = File.read!(file)

    get_score_for_line(input)
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day3-input") do
    input = File.read!(file)

    [first | rest] = Regex.split(~r/don't\(\)/, input)

    restscore =
      rest
      |> Enum.map(fn line ->
        [_ignore | keep] = Regex.split(~r/do\(\)/, line)

        keep
        |> Enum.map(&get_score_for_line/1)
        |> Enum.sum()
      end)
      |> Enum.sum()

    get_score_for_line(first) + restscore
  end

  defp get_score_for_line(line) do
    Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, line)
    |> Enum.map(fn [_, a, b] ->
      String.to_integer(a) * String.to_integer(b)
    end)
    |> Enum.sum()
  end
end
