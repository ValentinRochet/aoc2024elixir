defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  test "day5part1" do
    assert Day4.part1("input/day5-example") == 143
  end

  test "day5part2" do
    assert Day4.part2("input/day5-example") == 9
  end
end
