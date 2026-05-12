# lheap

> [Leftist heap](https://en.wikipedia.org/wiki/Leftist_tree) in Elixir

Version 2.0.0 diverges from 1.x in that all values provided to the heap must now be 2-tuples.
The first element of the tuple is used as the 'value' of the second element in the tree.


```
iex()> h = LHeap.new(%{1 => "one", 2 => "two"})
{{1, {1, "one"}}, {{1, {2, "two"}}, {}, {}}, {}}

iex()> h1 = LHeap.merge(h, LHeap.new(%{2 => "new-two", 3 => "new-three"}))
{{2, {1, "one"}}, {{1, {2, "two"}}, {}, {}},
 {{1, {2, "new-two"}}, {{1, {3, "new-three"}}, {}, {}}, {}}}

iex()> LHeap.sort(h1)
[{1, "one"}, {2, "new-two"}, {3, "new-three"}]

iex()> LHeap.min(h1)
{1, "one"}
```


## Install

In your `mix.exs`:

```elixir
defp deps do
  [
    {:lheap, "~> 2.0.0"}
  ]
end
```

Then run `mix deps.get`.

## API

Documentation is available in [HexDocs](https://hexdocs.pm/lheap).

### `LHeap.new/0`, `LHeap.new/1`

Creates a new empty heap. When given an enumerable, it will populate the new heap with it.

### `LHeap.put/2`

Puts a new value in a heap.

### `LHeap.min/1`

Returns the minimum element of a heap.

### `LHeap.remove_min/1`

Removes the minimum element from a heap.

### `LHeap.merge/2`

Merges two heaps.

### `LHeap.sort/1`

Sorts the given heap and returns a list.

## License

MIT © [Juan Soto](https://juansoto.me), [Simon Zelazny](https://pzel.name)
