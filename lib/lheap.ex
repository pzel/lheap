defmodule LHeap do
  @moduledoc """
  Leftist heaps in Elixir.

  This version requires that values be 2-tuples ({a,b}), where:
    * `a` is used to determine the position of the node in the heap
    * `b` is carried along as associated data

  Values with duplicate index `a` are overwritten on `put` and `merge`, where
  `merge` prefers its second argument.

  For general information about them, see [Wikipedia](https://en.wikipedia.org/wiki/Leftist_tree).

  Leftist heap elements are represented by a three element tuple of the form:

  `{{s-value, value}, left, right}`

  Where:
    * `s-value` is the distance from that node to the nearest leaf of the [extended binary tree representation](http://mathworld.wolfram.com/ExtendedBinaryTree.html)
    * `value`, is the actual value of the node
    * `left` and `right` are other heaps
  """

  @empty {}

  @doc """
  Creates a new, empty heap.

  ## Example

      iex> LHeap.new()
      {}
  """
  def new do
    @empty
  end

  @doc """
  Creates a new heap from a given enumerable.

  ## Example

      iex> LHeap.new([{4, :four}, {3, :three}, {8, :eight}])
      {{2, {3, :three}}, {{1, {4, :four}}, {}, {}}, {{1, {8, :eight}}, {}, {}}}

  """
  def new(enumerable) do
    enumerable
    |> Enum.reduce(@empty, &put(&2, &1))
  end

  @doc """
  Puts a new value in a heap, replacing the old value if present.

  ## Example

      iex> LHeap.new() |> LHeap.put({10, :ten}) |> LHeap.put({1, :one}) |> LHeap.put({5, :five})
      {{2, {1, :one}}, {{1, {10, :ten}}, {}, {}}, {{1, {5, :five}}, {}, {}}}
      iex> LHeap.new() |> LHeap.put({10, :ten}) |> LHeap.put({10, TEN})
      {{1, {10, TEN}}, {}, {}}


  """
  def put(lheap, {_, _} = value), do: merge(lheap, build(value))
  def put(_, value), do: raise(ArgumentError, "Expected tuple {idx, val}, got: #{inspect(value)}")

  @doc """
  Returns the minimum element of a heap.

  ## Example

      iex> LHeap.new([{10, :ten}, {1, :one}, {7, :seven}]) |> LHeap.min()
      {1, :one}
  """
  def min(@empty), do: nil
  def min({{_, value}, _, _}), do: value

  @doc """
  Removes the minimum element from a heap.

  ## Example

      iex> LHeap.new([{10, :ten}, {1, :one}, {7, :seven}]) |> LHeap.remove_min()
      {{1, {7, :seven}}, {{1, {10, :ten}}, {}, {}}, {}}

  """
  def remove_min(@empty), do: nil
  def remove_min({_, l, r}), do: merge(l, r)

  @doc """
  Merges two heaps.

  ## Example

      iex> heap1 = LHeap.new([{2, :two}, {4, :four}, {6, :six}])
      iex> heap2 = LHeap.new([{1, :one}, {3, :three}, {5, :five}])
      iex> LHeap.merge(heap1, heap2)
      {{2, {1, :one}},
       {{2, {2, :two}}, {{1, {4, :four}}, {}, {}},
        {{1, {5, :five}}, {{1, {6, :six}}, {}, {}}, {}}}, {{1, {3, :three}}, {}, {}}}

  """
  def merge(lheap1, @empty), do: lheap1
  def merge(@empty, lheap2), do: lheap2

  def merge(
        {{_, {k1, _} = v1}, left1, right1} = lheap1,
        {{_, {k2, _} = v2}, left2, right2} = lheap2
      ) do
    cond do
      k1 < k2 ->
        build(v1, left1, merge(right1, lheap2))

      k1 == k2 ->
        build(v2, left1, merge(right1, remove_min(lheap2)))

      true ->
        build(v2, left2, merge(lheap1, right2))
    end
  end

  @doc """
  Sorts the given heap and returns a list.

  ## Example

      iex> heap1 = LHeap.new([{2, :two}, {4, :four}, {6, :six}, {8, :eight}, {10, :ten}])
      iex> heap2 = LHeap.new([{1, :one}, {3, :three}, {5, :five}, {7, :seven}, {9, :nine}])
      iex> LHeap.merge(heap1, heap2) |> LHeap.sort()
      [
        {1, :one},
        {2, :two},
        {3, :three},
        {4, :four},
        {5, :five},
        {6, :six},
        {7, :seven},
        {8, :eight},
        {9, :nine},
        {10, :ten}
      ]

  """
  def sort(heap), do: sort(heap, [])
  defp sort(@empty, sorted), do: sorted |> Enum.reverse()

  defp sort(heap, sorted) do
    sort(remove_min(heap), [min(heap) | sorted])
  end

  defp s_val(@empty), do: 0
  defp s_val({{s_val, _}, _, _}), do: s_val

  defp build(v), do: build(v, @empty, @empty)

  defp build(v, l, r) do
    cond do
      s_val(l) >= s_val(r) ->
        {{s_val(r) + 1, v}, l, r}

      true ->
        {{s_val(l) + 1, v}, r, l}
    end
  end
end
