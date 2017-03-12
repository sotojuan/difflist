defmodule DiffList do
  @moduledoc """
  Difference lists are a way of encoding a list as the action of preappending them.

  Instead of a list being `[1, 2, 3]`, it is the anonymous function `fn(ys) -> [1, 2, 3] ++ ys end`.

  Difference lists are fast for left-associated appends (`list ++ [x]`) as they are represented as function composition.

  Refer to [this](http://h2.jaguarpaw.co.uk/posts/demystifying-dlist/) excellent blog post for more information.
  """

  alias DiffList.Utils

  @type difflist :: (list -> list)

  @doc """
  Converts a list into a difference list.
  """
  @spec from_list(list) :: difflist
  def from_list(xs) do
    fn ys -> xs ++ ys end
  end

  @doc """
  Convert a difference list into a list.

  ## Examples

      iex> DiffList.from_list([1, 2, 3]) |> DiffList.to_list
      [1, 2, 3]
  """
  @spec to_list(difflist) :: list
  def to_list(difflist) do
    difflist.([])
  end

  @doc """
  Returns an empty difference list.
  """
  @spec empty() :: difflist
  def empty, do: from_list([])

  @doc """
  Returns a difference list of one item.

  ## Example

      iex> DiffList.singleton(1) |> DiffList.to_list
      [1]
  """
  @spec singleton(any) :: difflist
  def singleton(x) do
    cons(empty(), x)
  end

  @doc """
  Append a difference list to another difference list.

  ## Example

      iex> x = DiffList.from_list([1, 2, 3])
      iex> y = DiffList.from_list([4, 5, 6])
      iex> DiffList.append(x, y) |> DiffList.to_list
      [1, 2, 3, 4, 5, 6]
  """
  @spec append(difflist, difflist) :: difflist
  def append(difflist_a, difflist_b) do
    Utils.compose(difflist_a, difflist_b)
  end

  @doc """
  Prepends an item to a difference list.

  The difference list equivalent of `[x] ++ list`.

  ## Example

      iex> x = DiffList.from_list([2, 3])
      iex> DiffList.cons(x, 1) |> DiffList.to_list
      [1, 2, 3]
  """
  @spec cons(difflist, any) :: difflist
  def cons(difflist, x) do
    Utils.compose(Utils.list_cons(x), difflist)
  end

  @doc """
  Appends an item to a difference list.

  The difference list equivalent of `list ++ [x]`.

  ## Example

      iex> x = DiffList.from_list([1, 2])
      iex> DiffList.snoc(x, 3) |> DiffList.to_list
      [1, 2, 3]
  """
  @spec snoc(difflist, any) :: difflist
  def snoc(difflist, x) do
    Utils.compose(difflist, Utils.list_cons(x))
  end

  @doc """
  Gets the first element of a difference list.

  Essentially the same as `hd(list)`.

  ## Example

      iex> x = DiffList.from_list([1, 2, 3])
      iex> DiffList.head(x)
      1
  """
  @spec head(difflist) :: any
  def head(difflist), do: list(&Utils.const/2, difflist)

  @doc """
  Gets the tail a difference list.

  Essentially the same as `tl(list)`.

  ## Example

      iex> x = DiffList.from_list([1, 2, 3])
      iex> DiffList.tail(x) |> DiffList.to_list
      [2, 3]
  """
  @spec tail(difflist) :: list
  def tail(difflist), do: list(&Utils.flipped_const/2, difflist)

  @doc """
  Concatenates a list of difference lists into one difference list.

  ## Example

      iex> x = DiffList.from_list([1, 2, 3])
      iex> y = DiffList.from_list([4, 5, 6])
      iex> z = [x, y]
      iex> DiffList.concat(z) |> DiffList.to_list
      [1, 2, 3, 4, 5, 6]
  """
  @spec concat(list(difflist)) :: difflist
  def concat(difflists) do
    Enum.reduce(difflists, empty(), fn(x, acc) -> append(acc, x) end)
  end

  defp list(fun, difflist) do
    case to_list(difflist) do
      [] -> nil
      [h | t] -> fun.(h, from_list(t))
    end
  end
end
