defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "day1part1" do
    assert Day1.part1("input/day1-example") == 11
  end

  test "day1part2" do
    assert Day1.part2("input/day1-example") == 31
  end
end
