defmodule UtilsTest do
  use ExUnit.Case, async: false
  use ExCheck

  property :compose do
    add_one = fn(x) -> x + 1 end

    for_all x in int(), do: Utils.compose(add_one, add_one).(x) == x + 2
  end

  property :list_cons do
    for_all {x, y} in {int(), int()}, do: Utils.list_cons(x).(y) == [x | y]
  end

  property :const do
    for_all {x, y} in {int(), int()}, do: Utils.const(x, y) == x
    for_all {x, y} in {int(), int()}, do: Utils.flipped_const(x, y) == y
  end
end
