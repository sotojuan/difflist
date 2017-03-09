defmodule Utils do
  @moduledoc false

  def compose(f, g) when is_function(g) do
    fn arg -> compose(f, g.(arg)) end
  end

  def compose(f, arg) do
    f.(arg)
  end

  def list_cons(x), do: fn(y) -> [x | y] end

  def const(a, b), do: a

  def flipped_const(a, b), do: b
end
