defmodule Day8 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day8-input") do
    input = File.read!(file)

    {grid, max_x, max_y} = parse_input(input)

    grid
    |> Enum.flat_map(fn {_char, pos} ->
      get_antinodes(pos)
    end)
    |> Enum.filter(fn {x, y} -> x >= 0 and x <= max_x and y >= 0 and y <= max_y end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp parse_input(input) do
    grid =
      input
      |> String.split("\r\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.filter(fn {char, _x} -> char != "." end)
        |> Enum.map(fn {char, x} ->
          {char, {x, y}}
        end)
      end)
      |> Enum.group_by(fn {char, _pos} -> char end, fn {_char, pos} -> pos end)
      |> Enum.map(fn {char, positions} -> {char, positions} end)

    max_y = input |> String.split("\r\n") |> length() |> Kernel.-(1)
    max_x = input |> String.split("\r\n") |> List.first() |> String.length() |> Kernel.-(1)

    {grid, max_x, max_y}
  end

  defp get_antinodes(positions) do
    if(length(positions) <= 1) do
      []
    else
      [base | rest] = positions

      {base_x, base_y} = base

      antinodes =
        rest
        |> Enum.flat_map(fn {x, y} ->
          dx = x - base_x
          dy = y - base_y

          [
            {base_x - dx, base_y - dy},
            {base_x + dx, base_y + dy},
            {x - dx, y - dy},
            {x + dx, y + dy}
          ]
          |> List.delete(base)
          |> List.delete({x, y})
        end)

      antinodes ++ get_antinodes(rest)
    end
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day8-input") do
    input = File.read!(file)

    {grid, max_x, max_y} = parse_input(input)

    grid
    |> Enum.flat_map(fn {_char, pos} ->
      get_antinodes_part_2(pos, max_x, max_y)
    end)
    |> Enum.filter(fn {x, y} -> x >= 0 and x <= max_x and y >= 0 and y <= max_y end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp get_antinodes_part_2(positions, max_x, max_y) do
    if(length(positions) <= 1) do
      []
    else
      [base | rest] = positions

      {base_x, base_y} = base

      antinodes =
        rest
        |> Enum.flat_map(fn {x, y} ->
          dx = x - base_x
          dy = y - base_y

          [base] ++
            resonant_harmonic(base_x, base_y, dx, dy, max_x, max_y) ++
            resonant_harmonic(base_x, base_y, -dx, -dy, max_x, max_y)
        end)

      antinodes ++ get_antinodes_part_2(rest, max_x, max_y)
    end
  end

  defp resonant_harmonic(x, y, dx, dy, max_x, max_y) do
    if x + dx >= 0 and x + dx <= max_x and y + dy >= 0 and y + dy <= max_y do
      [{x + dx, y + dy}] ++ resonant_harmonic(x + dx, y + dy, dx, dy, max_x, max_y)
    else
      []
    end
  end
end
