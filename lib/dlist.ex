defmodule DList do
  @moduledoc false

  def from_list(xs) do
    fn ys -> xs ++ ys end
  end

  def to_list(dlist) do
    dlist.([])
  end

  def empty, do: from_list([])

  def append(dlist_a, dlist_b) do
    Utils.compose(dlist_a, dlist_b)
  end

  def cons(dlist, x) do
    Utils.compose(Utils.list_cons(x), dlist)
  end

  def snoc(dlist, x) do
    Utils.compose(dlist, Utils.list_cons(x))
  end

  def head(dlist), do: list(&Utils.const/2, dlist)

  def tail(dlist), do: list(&Utils.flipped_const/2, dlist)

  def concat(dlists) do
    Enum.reduce(dlists, empty(), fn(x, acc) -> append(acc, x) end)
  end

  defp list(fun, dlist) do
    case to_list(dlist) do
      [] -> nil
      [h | t] -> fun.(h, from_list(t))
    end
  end
end
