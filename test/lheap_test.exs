defmodule LHeapTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  doctest LHeap

  def length_right_spine({}), do: 0
  def length_right_spine({_, _, r}), do: 1 + length_right_spine(r)
  def fst({k, _}), do: k

  # Generates a list of {integer(), term()} tuples where fst values are unique
  # across a check.
  defp unique_input_keys(opts \\ []) do
    min_length = opts[:min_length] || 0
    max_length = opts[:max_length] || 1000

    bind(uniq_list_of(integer(), min_length: min_length, max_length: max_length), fn xs ->
      map(
        list_of(term(), length: length(xs)),
        fn ys -> Enum.zip(xs, ys) end
      )
    end)
  end

  property "create new heap with sort" do
    check all(xs <- unique_input_keys()) do
      heap = LHeap.new(xs)

      assert LHeap.sort(heap) == Enum.sort(xs)
    end
  end

  property "only keys are used for heap membership (dupes removed)" do
    check all(xs <- list_of({integer(), binary()})) do
      heap = LHeap.new(xs)

      sorted_heap_keys = LHeap.sort(heap) |> Enum.map(&fst/1)
      input_key_set = xs |> Enum.map(&fst/1) |> MapSet.new() |> Enum.sort()

      assert sorted_heap_keys == input_key_set
    end
  end

  property "put and length of right spine" do
    check all(xs <- unique_input_keys()) do
      heap = LHeap.new(xs)
      spine_length = length_right_spine(heap)

      max_spine_length = :math.log2(length(xs) + 1)
      assert spine_length <= max_spine_length
    end
  end

  property "merge two heaps" do
    check all(xys <- unique_input_keys(min_length: 2)) do
      {xs, ys} = Enum.split(xys, div(length(xys), 2))
      x = LHeap.new(xs)
      y = LHeap.new(ys)
      heap = LHeap.merge(x, y)

      assert LHeap.sort(heap) == Enum.sort(xs ++ ys)
    end
  end

  test "heap merge prefers the right argument when keys are in conflict" do
    x = LHeap.new([{1, :a}, {3, 3}])
    y = LHeap.new([{1, :z}, {2, 2}])
    heap = LHeap.merge(x, y)

    assert LHeap.sort(heap) == [{1, :z}, {2, 2}, {3, 3}]
  end

  test "inputs must be tuples" do
    assert_raise ArgumentError, fn ->
      LHeap.new([1, 2, 3])
    end
  end
end
