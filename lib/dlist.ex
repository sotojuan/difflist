defmodule DList do
  @moduledoc """
  Difference lists are a way of encoding a list as the action of preappending them.

  Instead of a list being `[1, 2, 3]`, it is the anonymous function `fn(ys) -> [1, 2, 3] ++ ys end`.

  Difference lists are fast for left-associated appends (`list ++ [x]`) as they are represented as function composition.

  Refer to [this](http://h2.jaguarpaw.co.uk/posts/demystifying-dlist/) excellent blog post for more information.
  """

  alias DList.Utils

  @type dlist :: (list -> list)

  @doc """
  Converts a list into a difference list.
  """
  @spec from_list(list) :: dlist
  def from_list(xs) do
    fn ys -> xs ++ ys end
  end

  @doc """
  Convert a difference list into a list.

  ## Examples

      iex> DList.from_list([1, 2, 3]) |> DList.to_list
      [1, 2, 3]
  """
  @spec to_list(dlist) :: list
  def to_list(dlist) do
    dlist.([])
  end

  @doc """
  Returns an empty difference list.
  """
  @spec empty() :: dlist
  def empty, do: from_list([])

  @doc """
  Returns a difference list of one item.

  ## Example

      iex> DList.singleton(1) |> DList.to_list
      [1]
  """
  @spec singleton(any) :: dlist
  def singleton(x) do
    cons(empty(), x)
  end

  @doc """
  Append a difference list to another difference list.

  ## Example

      iex> x = DList.from_list([1, 2, 3])
      iex> y = DList.from_list([4, 5, 6])
      iex> DList.append(x, y) |> DList.to_list
      [1, 2, 3, 4, 5, 6]
  """
  @spec append(dlist, dlist) :: dlist
  def append(dlist_a, dlist_b) do
    Utils.compose(dlist_a, dlist_b)
  end

  @doc """
  Prepends an item to a difference list.

  The difference list equivalent of `[x] ++ list`.

  ## Example

      iex> x = DList.from_list([2, 3])
      iex> DList.cons(x, 1) |> DList.to_list
      [1, 2, 3]
  """
  @spec cons(dlist, any) :: dlist
  def cons(dlist, x) do
    Utils.compose(Utils.list_cons(x), dlist)
  end

  @doc """
  Appends an item to a difference list.

  The difference list equivalent of `list ++ [x]`.

  ## Example

      iex> x = DList.from_list([1, 2])
      iex> DList.snoc(x, 3) |> DList.to_list
      [1, 2, 3]
  """
  @spec snoc(dlist, any) :: dlist
  def snoc(dlist, x) do
    Utils.compose(dlist, Utils.list_cons(x))
  end

  @doc """
  Gets the first element of a difference list.

  Essentially the same as `hd(list)`.

  ## Example

      iex> x = DList.from_list([1, 2, 3])
      iex> DList.head(x)
      1
  """
  @spec head(dlist) :: any
  def head(dlist), do: list(&Utils.const/2, dlist)

  @doc """
  Gets the tail a difference list.

  Essentially the same as `tl(list)`.

  ## Example

      iex> x = DList.from_list([1, 2, 3])
      iex> DList.tail(x) |> DList.to_list
      [2, 3]
  """
  @spec tail(dlist) :: list
  def tail(dlist), do: list(&Utils.flipped_const/2, dlist)

  @doc """
  Concatenates a list of difference lists into one difference list.

  ## Example

      iex> x = DList.from_list([1, 2, 3])
      iex> y = DList.from_list([4, 5, 6])
      iex> z = [x, y]
      iex> DList.concat(z) |> DList.to_list
      [1, 2, 3, 4, 5, 6]
  """
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
