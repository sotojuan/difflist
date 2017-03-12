defmodule AppendBench do
  alias DiffList, as: DL
  use Benchfella

  # Regular left appending (`list ++ [item]`)
  # See https://hexdocs.pm/elixir/Kernel.html#++/2
  def list(i), do: list_append(i, [])
  def list_append(0, xs), do: xs
  def list_append(n, xs), do: list_append(n - 1, xs ++ [n])

  # Prepending via `[item | rest]` then reversing
  # See https://hexdocs.pm/elixir/Kernel.html#++/2
  def reverse(i), do: reverse_append(i, [])
  def reverse_append(0, xs), do: xs
  def reverse_append(n, xs), do: reverse_append(n - 1, Enum.reverse([n | xs]))

  # Difference list
  def difflist(i), do: difflist_append(i, DL.empty)
  def difflist_append(0, xs), do: xs
  def difflist_append(n, xs), do: difflist_append(n - 1, DL.append(xs, DL.singleton(n)))

  bench "regular list append" do
    list(10000)
  end

  bench "reverse list append" do
    reverse(10000)
  end

  bench "difflist append" do
    difflist(10000)
  end
end
