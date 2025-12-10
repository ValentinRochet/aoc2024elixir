defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  test "day10part1" do
    assert Day10.part1("input/day10-example") == 36
  end

  test "day10part2" do
    assert Day10.part2("input/day10-example") == 81
  end
end
