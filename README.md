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

In a Livebook cell:

```elixir
vault_path = "/path/to/obsidian/vault"
Obsidian.publish(vault_path)
```
