defmodule AbbrevTest do
  use ExUnit.Case
  doctest Abbrev

  test "greets the world" do
    assert Abbrev.hello() == :world
  end
end
