defmodule DListTest do
  use ExUnit.Case, async: false
  use ExCheck

  property :list_conversion do
    for_all xs in list(int()) do
      dlist = DList.from_list(xs)

      DList.to_list(dlist) == xs
    end
  end

  property :append do
    for_all {xs, ys} in {list(int()), list(int())} do
      dlist_a = DList.from_list(xs)
      dlist_b = DList.from_list(ys)

      dlist_c = DList.append(dlist_a, dlist_b)

      DList.to_list(dlist_c) == xs ++ ys
    end
  end

  property :cons do
    for_all {xs, x} in {list(int()), int()} do
      dlist_a = DList.from_list(xs)
      dlist_b = DList.cons(dlist_a, x)

      DList.to_list(dlist_b) == [x] ++ xs
    end
  end

  property :snoc do
    for_all {xs, x} in {list(int()), int()} do
      dlist_a = DList.from_list(xs)
      dlist_b = DList.snoc(dlist_a, x)

      DList.to_list(dlist_b) == xs ++ [x]
    end
  end

  property :head do
    for_all xs in such_that(ys in list(int()) when length(ys) > 0) do
      dlist = DList.from_list(xs)

      DList.head(dlist) == hd(xs)
    end
  end

  property :tail do
    for_all xs in such_that(ys in list(int()) when length(ys) > 0) do
      dlist = DList.from_list(xs)
      tail = dlist |> DList.tail |> DList.to_list

      tail == tl(xs)
    end
  end

  property :concat do
    for_all {xs, ys} in {list(int()), list(int())} do
      lists = [DList.from_list(xs), DList.from_list(ys)]
      result = DList.concat(lists)

      DList.to_list(result) == xs ++ ys
    end
  end
end
