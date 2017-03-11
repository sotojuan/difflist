defmodule Utils do
  @moduledoc false

  # 1-arity function
  @type func_one :: (any -> any)

  @spec compose(func_one, func_one) :: func_one
  def compose(f, g) when is_function(g) do
    fn arg -> compose(f, g.(arg)) end
  end

  @spec compose(func_one, any) :: any
  def compose(f, arg) do
    f.(arg)
  end

  @spec list_cons(any) :: (any -> [any])
  def list_cons(x), do: fn(y) -> [x | y] end

  @spec const(any, any) :: any
  def const(a, _b), do: a

  @spec flipped_const(any, any) :: any
  def flipped_const(_a, b), do: b
end
