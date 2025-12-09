defmodule Day9 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day9-input") do
    input = File.read!(file)

    disk =
      input
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.flat_map(fn {n, i} ->
        if rem(i, 2) == 0 do
          List.duplicate(i / 2, String.to_integer(n))
        else
          List.duplicate(:empty, String.to_integer(n))
        end
      end)

    IO.puts("Starting optimization")
    optimized_disk = optimize(disk)

    IO.puts("Calculating score")
    calculate_score(optimized_disk)
  end

  defp optimize(disk) do
    if Enum.member?(disk, :empty) do
      [block | rest] = disk

      if block == :empty do
        {new_block, new_disk} = get_last_block(rest)
        [new_block] ++ optimize(new_disk)
      else
        # good position
        [block] ++ optimize(rest)
      end
    else
      # end : no more empty space
      disk
    end
  end

  defp get_last_block(disk) do
    if rem(length(disk), 100) == 1, do: IO.write(".")

    [last | rest] = Enum.reverse(disk)

    if last == :empty do
      # no use of this block
      get_last_block(Enum.reverse(rest))
    else
      {last, Enum.reverse(rest)}
    end
  end

  defp calculate_score(disk, pos \\ 0)

  defp calculate_score([], _pos) do
    0
  end

  defp calculate_score([head | rest], pos) do
    if head == :empty do
      0 + calculate_score(rest, pos + 1)
    else
      pos * head + calculate_score(rest, pos + 1)
    end
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day9-input") do
    input = File.read!(file)

    disk =
      input
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {n, i} ->
        if rem(i, 2) == 0 do
          {i, i / 2, String.to_integer(n)}
        else
          {i, :empty, String.to_integer(n)}
        end
      end)
      |> Enum.filter(fn {_, _, size} -> size > 0 end)

    top_id = disk |> Enum.map(fn {id, _, _} -> id end) |> Enum.max()

    IO.puts("Starting optimization")
    optimized_disk = optimize_part_2(disk, top_id)

    IO.puts("Calculating score")
    calculate_score(optimized_disk)
  end

  defp optimize_part_2([], _top_id) do
    []
  end

  defp optimize_part_2(disk, top_id) do
    if rem(length(disk), 100) == 1, do: IO.write(".")
    [{_, last_block_type, last_block_size} | rest_inversed] = Enum.reverse(disk)

    if last_block_type == :empty do
      optimize_part_2(Enum.reverse(rest_inversed), top_id) ++
        List.duplicate(:empty, last_block_size)
    else
      free_block =
        Enum.reverse(rest_inversed)
        |> Enum.find(fn {_, type, size} -> type == :empty and size >= last_block_size end)

      if free_block == nil do
        optimize_part_2(Enum.reverse(rest_inversed), top_id) ++
          List.duplicate(last_block_type, last_block_size)
      else
        {block_id, _, block_size} = free_block

        updated =
          Enum.reverse(rest_inversed)
          |> Enum.flat_map(fn {id, type, size} ->
            if id == block_id do
              # Un élément devient plusieurs
              if block_size == last_block_size do
                [{id, last_block_type, last_block_size}]
              else
                [{id, last_block_type, last_block_size}] ++
                  [{top_id + 1, :empty, block_size - last_block_size}]
              end
            else
              # Un élément reste un élément
              [{id, type, size}]
            end
          end)

        optimize_part_2(updated, top_id + 1) ++ List.duplicate(:empty, last_block_size)
      end
    end
  end
end
