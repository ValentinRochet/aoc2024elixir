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

    positions_to_test =
      original_path
      |> MapSet.delete({start_x, start_y})
      |> Enum.to_list()

    grid_size = map_size(grid)
    max_possible_states = grid_size * 4  # 4 directions

    IO.puts("Nombre de positions à tester: #{length(positions_to_test)}")
    IO.puts("Nombre de cœurs CPU: #{System.schedulers_online()}")
    IO.puts("Limite d'états possibles: #{max_possible_states}")

    positions_to_test
    |> Task.async_stream(
      fn {x, y} ->
        new_grid = Map.put(grid, {x, y}, "#")
        result = move_with_memory(new_grid, start_x, start_y, :top, MapSet.new())
        IO.write(".")
        result
      end,
      max_concurrency: System.schedulers_online(),
      timeout: 30_000,
      on_timeout: :kill_task
    )
    |> Enum.reduce(0, fn
      {:ok, true}, acc -> acc + 1
      {:ok, false}, acc -> acc
      {:exit, :timeout}, acc ->
        IO.puts("\n⚠️  Timeout sur une position!")
        acc
    end)
  end

  defp move_with_memory(grid, x, y, direction, path, max_steps \\ 20_000) do
    cond do
      max_steps <= 0 ->
        # Trop d'étapes = boucle probable
        true

      MapSet.member?(path, {x, y, direction}) ->
        # Vraie boucle détectée
        true

      not Map.has_key?(grid, {x, y}) ->
        # Sorti de la grille
        false

      true ->
        # Continue l'exploration
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
    end
  end
end
