defmodule Day5 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day5-input") do
    input = File.read!(file)

    [ordering, pages] =
      input
      |> String.split("\r\n\r\n", parts: 2)
      |> Enum.map(&String.split(&1, "\r\n"))

    page_ordering =
      ordering
      |> Enum.map(&String.split(&1, "|"))

    pages
    |> Enum.map(&String.split(&1, ","))
    |> Enum.filter(&is_page_order_correct?(&1, page_ordering))
    |> Enum.map(&Enum.at(&1, div(length(&1), 2)))
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp is_page_order_correct?(page, page_ordering) do
    if length(page) < 2 do
      true
    else
      [first | rest] = page

      error =
        Enum.filter(page_ordering, fn [_, second] -> second == first end)
        |> Enum.map(fn [x, _y] ->
          x
        end)
        |> Enum.filter(fn x ->
          Enum.member?(rest, x)
        end)
        |> Enum.count()

      if error > 0 do
        false
      else
        is_page_order_correct?(rest, page_ordering)
      end
    end
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day5-input") do
    input = File.read!(file)

    [ordering, pages] =
      input
      |> String.split("\r\n\r\n", parts: 2)
      |> Enum.map(&String.split(&1, "\r\n"))

    page_ordering =
      ordering
      |> Enum.map(&String.split(&1, "|"))

    pages
    |> Enum.map(&String.split(&1, ","))
    |> Enum.reject(&is_page_order_correct?(&1, page_ordering))
    |> Enum.map(fn x ->
      correct_page_order(x, page_ordering)
    end)
    |> Enum.map(&Enum.at(&1, div(length(&1), 2)))
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def correct_page_order(_page, _page_ordering) do
    [""]
  end
end
