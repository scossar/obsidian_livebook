# Obsidian Livebook

Publish a [Livebook](https://livebook.dev/) to a local Obsidian vault.

## Installation

Install in a Livebook's setup cell:

```elixir
Mix.install([
  {:obsidian_livebook, path: "/absolute/path/to/obsidian_livebook"}
])
```

## Usage

Make sure the Livebook has been saved to disk, then:
In a Livebook cell:

```elixir
vault_path = "/path/to/obsidian/vault"
Obsidian.publish(vault_path, __ENV__.file)
```

In IEx:

```text
iex(2)> ObsidianLivebook.publish("/path/to/obsidian_vault", "/path/to/livebook_publish_test_two.livemd", force: true)
Published and opened.
:ok
```
