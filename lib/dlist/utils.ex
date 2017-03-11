defmodule Utils do
  @moduledoc false

  # 1-arity function
  @type func_one :: (any -> any)

  @doc false
  @spec compose(func_one, func_one) :: func_one
  def compose(f, g) when is_function(g) do
    fn arg -> compose(f, g.(arg)) end
  end

  @doc false
  @spec compose(func_one, any) :: any
  def compose(f, arg) do
    f.(arg)
  end

  @doc false
  @spec list_cons(any) :: (any -> [any])
  def list_cons(x), do: fn(y) -> [x | y] end

  @doc false
  @spec const(any, any) :: any
  def const(a, _b), do: a

  @doc false
  @spec flipped_const(any, any) :: any
  def flipped_const(_a, b), do: b
end
