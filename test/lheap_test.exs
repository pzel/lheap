defmodule LHeapTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  def length_right_spine({}), do: 0
  def length_right_spine({_, _, r}), do: 1 + length_right_spine(r)

  property "create new heap with sort" do
    check all(xs <- list_of(integer())) do
      heap = LHeap.new(xs)

      assert LHeap.sort(heap) == Enum.sort(xs)
    end
  end

  property "put and length of right spine" do
    check all(xs <- list_of(integer())) do
      heap = LHeap.new(xs)
      spine_length = length_right_spine(heap)

      max_spine_length = :math.log2(length(xs) + 1)
      assert spine_length <= max_spine_length
    end
  end

  property "merge two heaps" do
    check all({xs, ys} <- {list_of(integer()), list_of(integer())}) do
      x = LHeap.new(xs)
      y = LHeap.new(ys)
      heap = LHeap.merge(x, y)

      assert LHeap.sort(heap) == Enum.sort(xs ++ ys)
    end
  end
end
