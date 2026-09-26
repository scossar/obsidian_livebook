defmodule ObsidianLivebookTest do
  use ExUnit.Case
  doctest ObsidianLivebook

  test "greets the world" do
    assert ObsidianLivebook.hello() == :world
  end
end
