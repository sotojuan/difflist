# dlist

> [Difference lists](https://en.wikipedia.org/wiki/Difference_list) in Elixir

## Install

In your `mix.exs`:

```elixir
defp deps do
  [
    {:dlist, "~> 1.0.0"}
  ]
end
```

Then run `mix deps.get`.

## Usage

The best place to read the documentation is in [HexDocs](https://hexdocs.pm/dlist/) or in `iex` (e.g. `h DList.from_list`).

This package exposes a `DList` module with the following functions:

### Creating difference lists

#### `DList.from_list/1`

Creates a difference list from a regular list.

#### `DList.empty/0`

Creates an empty difference list.

#### `DList.singleton/1`

Creates a difference list of one element.

### Using difference lists

#### `DList.append/2`

Appends a difference list to another difference list.

#### `DList.cons/2`

Prepends an item to a difference list.

#### `DList.snoc/2`

Appends an item to a difference list.

#### `DList.head/1`

Gets the first item of a difference list.

#### `DList.tail/1`

Gets the tail (a difference list of everything but the first item) of a difference list.

#### `DList.concat/1`

Concatenates a list of difference lists into one difference list.

## Benchmark

A simple left-associated append benchmark is included. Run `mix bench` to run it.

## License

MIT © [Juan Soto](https://juansoto.me)
