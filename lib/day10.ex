defmodule Day10 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day10-input") do
    input = File.read!(file)

    map =
      input
      |> String.split("\r\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {c, x} ->
          {{x, y}, String.to_integer(c)}
        end)
      end)
      |> Map.new()

    map
    |> Enum.filter(fn {_, h} ->
      h == 0
    end)
    |> Enum.map(fn {{x, y}, _} ->
      climb(map, x, y, 0)
      |> Enum.uniq()
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp climb(_, x, y, 9) do
    {x, y}
  end

  defp climb(map, x, y, height) do
    get_adj_cases(x, y)
    |> Enum.filter(fn pos -> Map.get(map, pos) == height + 1 end)
    |> Enum.map(fn {x, y} ->
      climb(map, x, y, height + 1)
    end)
    |> List.flatten()
  end

  defp get_adj_cases(x, y) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day10-input") do
    input = File.read!(file)

    map =
      input
      |> String.split("\r\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {c, x} ->
          {{x, y}, String.to_integer(c)}
        end)
      end)
      |> Map.new()

    map
    |> Enum.filter(fn {_, h} ->
      h == 0
    end)
    |> Enum.map(fn {{x, y}, _} ->
      climb(map, x, y, 0)
      |> Enum.count()
    end)
    |> Enum.sum()
  end
end
