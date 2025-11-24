defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "day4part1" do
    assert Day4.part1("input/day4-example") == 18
  end

  test "day4part2" do
    assert Day4.part2("input/day4-example") == 9
  end
end
