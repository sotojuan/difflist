defmodule DiffListTest do
  use ExUnit.Case, async: false
  use ExCheck
  doctest DiffList

  property :list_conversion do
    for_all xs in list(int()) do
      difflist = DiffList.from_list(xs)

      DiffList.to_list(difflist) == xs
    end
  end

  property :singleton do
    for_all x in int() do
      difflist = DiffList.singleton(x)

      DiffList.to_list(difflist) == [x]
    end
  end

  property :append do
    for_all {xs, ys} in {list(int()), list(int())} do
      difflist_a = DiffList.from_list(xs)
      difflist_b = DiffList.from_list(ys)

      difflist_c = DiffList.append(difflist_a, difflist_b)

      DiffList.to_list(difflist_c) == xs ++ ys
    end
  end

  property :cons do
    for_all {xs, x} in {list(int()), int()} do
      difflist_a = DiffList.from_list(xs)
      difflist_b = DiffList.cons(difflist_a, x)

      DiffList.to_list(difflist_b) == [x] ++ xs
    end
  end

  property :snoc do
    for_all {xs, x} in {list(int()), int()} do
      difflist_a = DiffList.from_list(xs)
      difflist_b = DiffList.snoc(difflist_a, x)

      DiffList.to_list(difflist_b) == xs ++ [x]
    end
  end

  property :head do
    for_all xs in such_that(ys in list(int()) when length(ys) > 0) do
      difflist = DiffList.from_list(xs)

      DiffList.head(difflist) == hd(xs)
    end
  end

  property :tail do
    for_all xs in such_that(ys in list(int()) when length(ys) > 0) do
      difflist = DiffList.from_list(xs)
      tail = difflist |> DiffList.tail |> DiffList.to_list

      tail == tl(xs)
    end
  end

  property :concat do
    for_all {xs, ys} in {list(int()), list(int())} do
      lists = [DiffList.from_list(xs), DiffList.from_list(ys)]
      result = DiffList.concat(lists)

      DiffList.to_list(result) == xs ++ ys
    end
  end
end
