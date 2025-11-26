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

    move(grid, start_x, start_y)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp move(grid, x, y, direction \\ :top) do
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
      :top -> {x, y - 1}
      :down -> {x, y + 1}
      :right -> {x + 1, y}
      :left -> {x - 1, y}
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
      :top -> :right
      :right -> :down
      :down -> :left
      :left -> :top
    end
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day6-input") do
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

    original_path = move(grid, start_x, start_y) |> MapSet.new()

    original_path
    |> MapSet.delete({start_x, start_y})
    |> Task.async_stream(
      fn {x, y} ->
        new_grid = Map.put(grid, {x, y}, "#")
        move_with_memory(new_grid, start_x, start_y, :top, MapSet.new())
      end,
      max_concurrency: System.schedulers_online()
    )
    |> Enum.count(fn {:ok, result} -> result end)
  end

  defp move_with_memory(grid, x, y, direction, path, max_steps \\ 20_000) do
    if max_steps <= 0 do
      true
    else
      if MapSet.member?(path, {x, y, direction}) do
        true
      else
        if Map.has_key?(grid, {x, y}) do
          direction = turn_until_free(grid, direction, x, y)
          {next_step_x, next_step_y} = next_step(direction, x, y)

          move_with_memory(
            grid,
            next_step_x,
            next_step_y,
            direction,
            MapSet.put(path, {x, y, direction}),
            max_steps - 1
          )
        else
          false
        end
      end
    end
  end
end
