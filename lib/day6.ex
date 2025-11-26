defmodule Day6 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day6-input") do
    input = File.read!(file)

    grid =
      input
      |> String.split("\r\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {char, x} ->
          {{x, y}, char}
        end)
      end)
      |> Map.new()

    {{start_x, start_y}, _char} =
      grid
      |> Enum.find(fn {{_x, _y}, char} ->
        char == "^"
      end)

    move(grid, start_x, start_y, "top")
    |> Enum.uniq()
    |> Enum.count()

  end

  defp move(grid, x, y, direction) do
    if Map.has_key?(grid, {x, y}) do
      direction = turn_until_free(grid, direction, x, y)

      {next_step_x, next_step_y} = next_step(direction, x, y)

      [{x, y} | move(grid, next_step_x, next_step_y, direction)]
    else
      []
    end
  end

  defp next_step(direction, x, y) do
    case direction do
      "top" -> {x, y - 1}
      "down" -> {x, y + 1}
      "right" -> {x + 1, y}
      "left" -> {x - 1, y}
    end
  end

  defp turn_until_free(grid, direction, x, y) do
    next_pos = next_step(direction, x, y)

    if grid[next_pos] == "#" do
      turn_until_free(grid, make_turn(direction), x, y)
    else
      direction
    end
  end

  defp make_turn(direction) do
    case direction do
      "top" -> "right"
      "right" -> "down"
      "down" -> "left"
      "left" -> "top"
    end
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/6-example") do
    _input = File.read!(file)
  end
end
