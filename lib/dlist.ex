defmodule DList do
  @moduledoc false

  @type dlist :: (list -> list)

  @spec from_list(list) :: dlist
  def from_list(xs) do
    fn ys -> xs ++ ys end
  end

  @spec to_list(dlist) :: list
  def to_list(dlist) do
    dlist.([])
  end

  @spec empty() :: dlist
  def empty, do: from_list([])

  @spec singleton(any) :: dlist
  def singleton(x) do
    cons(empty(), x)
  end

  @spec append(dlist, dlist) :: dlist
  def append(dlist_a, dlist_b) do
    Utils.compose(dlist_a, dlist_b)
  end

  @spec cons(dlist, any) :: dlist
  def cons(dlist, x) do
    Utils.compose(Utils.list_cons(x), dlist)
  end

  @spec snoc(dlist, any) :: dlist
  def snoc(dlist, x) do
    Utils.compose(dlist, Utils.list_cons(x))
  end

  @spec head(dlist) :: any
  def head(dlist), do: list(&Utils.const/2, dlist)

  @spec tail(dlist) :: list
  def tail(dlist), do: list(&Utils.flipped_const/2, dlist)

  @spec concat(list(dlist)) :: dlist
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
