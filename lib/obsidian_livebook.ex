defmodule ObsidianLivebook do
  @moduledoc """
  Publish a Livebook to an Obsidian vault.
  """

  @doc ~S"""
  Publish the current Livebook to an Obsidian vault.

  ## Examples

      vault_path = "/home/scossar/obsidian_vault"

      Obsidian.publish(vault_path)
      Published and opened.
      :ok

      Obsidian.publish(vault_path)
      `/home/scossar/obsidian_vault/Publishing Livebooks to Obsidian.md` exists.
      Publish with `force: true` to overwrite.
      {:error, :already_exists}

      Obsidian.publish(vault_path, force: true)
      Published and opened.
      :ok
  """
  def publish(vault_path, opts \\ []) do
    force? = Keyword.get(opts, :force, false)

    [livebook_path, _cell_id] =
      String.split(__ENV__.file, "#cell:", parts: 2)

    true = String.ends_with?(livebook_path, ".livemd")

    # `"# " <> title` checks the heading prefix and extracts the title
    ["# " <> title, content] =
      livebook_path
      |> File.read!()
      |> String.split("\n\n", parts: 2)

    title = String.trim(title)
    true = String.trim(title) != ""
    false = String.contains?(title, ["/", ":", "\\", "\n", "\r", <<0>>])

    true = String.trim(content) != ""

    content = clean_content(content)

    output_path = Path.join(vault_path, title <> ".md")

    if note_exists?(output_path) and not force? do
      IO.puts("`#{output_path}` exists.\nPublish with `force: true` to overwrite.")
      {:error, :already_exists}
    else
      File.write!(output_path, content)

      case open_note("obsidian_vault", Path.relative_to(output_path, vault_path)) do
        :ok ->
          IO.puts("Published and opened.")

        {:error, {_status, output}} ->
          IO.puts("Published, but couldn't open the note:\n#{output}")
      end
    end
  end

  defp note_exists?(path) do
    case File.stat(path) do
      {:ok, _stat} ->
        true

      {:error, :enoent} ->
        false

      {:error, reason} ->
        raise File.Error,
          reason: reason,
          action: "inspect note",
          path: path
    end
  end

  defp clean_content(content) do
    reg = ~r/\n<!-- livebook:{"break_markdown":true} -->\n/
    String.replace(content, reg, "")
  end

  defp open_note(vault_name, relative_path) do
    query =
      URI.encode_query(
        %{"vault" => vault_name, "file" => relative_path, "paneType" => "tab"},
        :rfc3986
      )

    case System.cmd("xdg-open", ["obsidian://open?" <> query], stderr_to_stdout: true) do
      {_output, 0} -> :ok
      {output, status} -> {:error, {status, output}}
    end
  end
end
