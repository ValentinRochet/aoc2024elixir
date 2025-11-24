defmodule Day4 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day4-input") do
    input =
      File.read!(file)
      |> parse_grid_1()

    all_lines =
      horizontal_lines(input) ++
        vertical_lines(input) ++
        diagonal_down_right(input) ++
        diagonal_down_left(input)

    xmas =
      all_lines
      |> Enum.map(fn line ->
        String.split(line, "XMAS")
        |> length()
        |> Kernel.-(1)
      end)
      |> Enum.sum()

    samx =
      all_lines
      |> Enum.map(fn line ->
        String.split(line, "SAMX")
        |> length()
        |> Kernel.-(1)
      end)
      |> Enum.sum()

    xmas + samx
  end

  defp parse_grid_1(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(&String.graphemes/1)
  end

  defp horizontal_lines(grid) do
    Enum.map(grid, &Enum.join/1)
  end

  defp vertical_lines(grid) do
    grid
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.join/1)
  end

  defp diagonal_down_right(grid) do
    height = length(grid)
    width = length(hd(grid))

    top_diags =
      for row <- 0..(height - 1) do
        get_diagonal(grid, row, 0, height, width)
      end

    side_diags =
      for col <- 1..(width - 1) do
        get_diagonal(grid, 0, col, height, width)
      end

    (top_diags ++ side_diags)
    |> Enum.map(&Enum.join/1)
    |> Enum.filter(&(String.length(&1) > 0))
  end

  defp diagonal_down_left(grid) do
    grid
    |> Enum.map(&Enum.reverse/1)
    |> diagonal_down_right()
  end

  defp get_diagonal(grid, start_row, start_col, height, width) do
    Stream.iterate({start_row, start_col}, fn {r, c} -> {r + 1, c + 1} end)
    |> Enum.take_while(fn {r, c} -> r < height and c < width end)
    |> Enum.map(fn {r, c} -> Enum.at(Enum.at(grid, r), c) end)
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day4-input") do
    {grid, width, height} =
      File.read!(file)
      |> parse_grid_2()

    positions_of_a = find_char_in_grid(grid, "A")

    positions_of_a
    |> Enum.filter(fn {x, y} ->
      x != 0 && x != width && y != 0 && y != height
    end)
    |> Enum.filter(fn {x, y} ->
      ul = if is_mas_up_left_diagonal(grid, x, y), do: 1, else: 0
      ur = if is_mas_up_right_diagonal(grid, x, y), do: 1, else: 0
      dl = if is_mas_down_left_diagonal(grid, x, y), do: 1, else: 0
      dr = if is_mas_down_right_diagonal(grid, x, y), do: 1, else: 0

      ul + ur + dl + dr >= 2
    end)
    |> Enum.count()
  end

  defp parse_grid_2(text) do
    lines = String.split(text, "\r\n")
    height = length(lines)
    width = lines |> hd() |> String.length()

    grid =
      lines
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {char, x} -> {{x, y}, char} end)
      end)
      |> Map.new()

    {grid, width, height}
  end

  defp find_char_in_grid(grid, searched_char) do
    grid
    |> Enum.filter(fn {_pos, char} -> char == searched_char end)
    |> Enum.map(fn {pos, _char} -> pos end)
  end

  defp is_mas_up_right_diagonal(grid, x, y) do
    grid[{x - 1, y + 1}] == "M" && grid[{x + 1, y - 1}] == "S"
  end

  defp is_mas_down_right_diagonal(grid, x, y) do
    grid[{x - 1, y - 1}] == "M" && grid[{x + 1, y + 1}] == "S"
  end

  defp is_mas_up_left_diagonal(grid, x, y) do
    grid[{x + 1, y + 1}] == "M" && grid[{x - 1, y - 1}] == "S"
  end

  defp is_mas_down_left_diagonal(grid, x, y) do
    grid[{x + 1, y - 1}] == "M" && grid[{x - 1, y + 1}] == "S"
  end
end
