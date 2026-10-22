---
name: fix-todos
description: Resolve TODO(<agent>) / FIXME(<agent>) markers — instructions the user left in code for you, where `<agent>` is your own handle (`claude`, `codex`, `gemini`, …) or the generic `ai` / `agent`. Use when asked to fix the TODOs / FIXMEs, or when you spot such a marker addressed to you while working.
---

# Fix TODO(<agent>) / FIXME(<agent>)

Each `TODO(<agent>)` / `FIXME(<agent>)` addressed to you is a direct request from the user, written in place. The job is done when every one of them is resolved: fixed and its comment removed, or settled by the user.

## Step 1: Pick your handles

Your handles are your own short lowercase name plus the generic `ai` and `agent`:

| If you are…             | Handle              |
| ----------------------- | ------------------- |
| Anthropic Claude        | `claude`            |
| OpenAI Codex / ChatGPT  | `codex`             |
| Google Gemini           | `gemini`            |
| Cursor's built-in agent | `cursor`            |
| GitHub Copilot          | `copilot`           |
| Aider                   | `aider`             |
| Pi                      | `pi`                |
| Something else          | your own short name |

If you genuinely cannot tell which handle the user wrote, ask: _"Which marker should I search for — `TODO(<your-guess>)`, or something else?"_

## Step 2: Find every marker

Search the working directory with `rg`, case-insensitive, tolerating typos of your name:

```
(?i)(TODO|FIXME)\((<handle>|ai|agent)\)
```

For Claude: `(?i)(TODO|FIXME)\((cl[au]{2}de|ai|agent)\)` (catches `cluade`).

List the hits as a numbered list: file path, line number, full comment text. This list is your worklist.

Markers addressed to anyone else stay untouched. A marker for a _different_ agent (you are Codex and see `TODO(claude)`) is worth one mention to the user; act on it only if they confirm.

## Step 3: Resolve each marker

Classify each item on the worklist:

- **Clear**: one reasonable reading ("add field X", "rename Z to W", "move this to …"). Fix it directly.
- **Unclear**: several reasonable readings, or a design decision that belongs to the user. Present your interpretation and the options, wait for the answer, then fix.

For every fix:

1. Make the change the comment describes.
2. **Propagate** it to every reference across layers (e.g. IDL → generated code → model → DAL → service → handler → frontend), running the project's code generator when one exists (e.g. `make update-idl`).
3. Delete the marker comment.

## Step 4: Verify

1. Re-run the Step 2 search: the only hits left are unclear items the user chose to defer.
2. Run the project's build (find it in `Makefile`, `package.json`, etc.) until it passes; a failure usually means a reference you missed while propagating.
3. Report each worklist item with what changed, plus the build result.
