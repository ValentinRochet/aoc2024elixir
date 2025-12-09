defmodule Day8Test do
  use ExUnit.Case
  doctest Day8

  test "day8part1" do
    assert Day8.part1("input/day8-example") == 14
  end

  test "day8part2" do
    assert Day8.part2("input/day8-example") == 34
  end
end
