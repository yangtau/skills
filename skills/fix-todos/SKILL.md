---
name: fix-todos
description: Scan the codebase for TODO(<agent>) and FIXME(<agent>) comments left by the user as instructions for the current agent to act on, then fix them. The `<agent>` handle is whatever the running agent calls itself (e.g. `claude`, `codex`, `gemini`, `cursor`, `copilot`, `aider`). Use this skill when the user says "/fix-todos", "fix the TODOs", "handle the FIXMEs", or when you notice TODO/FIXME markers addressed to you in files you're working with. Also trigger proactively if you see such markers during normal work — they are explicit instructions from the user to you.
---

# Fix TODO(<agent>) / FIXME(<agent>)

You are tasked with finding and resolving all `TODO(<agent>)` and `FIXME(<agent>)` comments in the codebase, where `<agent>` is **your own name / handle**. These are instructions the user has left specifically for you to act on — treat them as direct requests.

## Step 0: Identify yourself

Before searching, figure out **what handle the user most likely used to address you**. Use your own identity — do not default to "claude" unless that is actually your name.

Pick the short lowercase handle that matches you, for example:

| If you are…              | Likely handle(s)          |
| ------------------------ | ------------------------- |
| Anthropic Claude         | `claude`                  |
| OpenAI Codex / ChatGPT   | `codex`, `chatgpt`, `gpt` |
| Google Gemini            | `gemini`                  |
| Cursor's built-in agent  | `cursor`                  |
| GitHub Copilot           | `copilot`                 |
| Aider                    | `aider`                   |
| Something else           | your own short name       |

Also always include a generic `ai` / `agent` marker as a fallback, since users sometimes write `TODO(ai)` regardless of which agent is running.

If you are genuinely unsure which handle the user picked, briefly ask: *"Which marker should I search for — `TODO(<your-guess>)`, or something else?"* before proceeding.

## Step 1: Find all markers

Search the working directory for `TODO(...)` and `FIXME(...)` comments whose argument matches your handle(s) from Step 0. Match case-insensitively and tolerate common typos of your own name (e.g. `cluade` for `claude`).

Concretely, build a regex like:

```
(?i)(TODO|FIXME)\((<handle1>|<handle2>|ai|agent)\)
```

For Claude specifically, that becomes: `(?i)(TODO|FIXME)\((cl[au]{2}de|ai|agent)\)` to also catch the `cluade` typo.

Use `rg` / Grep with that pattern. Report what you found as a numbered list with file path, line number, and the full comment text.

## Step 2: Classify each item

For each TODO/FIXME, classify it:

- **Clear**: The intent is unambiguous and actionable (e.g., "add field X", "remove Y", "rename Z to W", "move this to..."). You can fix these without asking.
- **Unclear**: The intent is ambiguous, has multiple reasonable interpretations, or requires a design decision the user should make. Ask before proceeding.

## Step 3: Fix clear items, ask about unclear ones

For **clear** items:
1. Make the code change described in the TODO/FIXME
2. Remove the TODO/FIXME comment after fixing
3. Propagate changes — if the fix affects other files (e.g., renaming a field in an IDL requires updating model structs, DAL layers, handlers, etc.), find and update all references

For **unclear** items:
1. Present each one to the user with your interpretation and any options you see
2. Wait for the user's decision before proceeding
3. Fix based on their answer, then remove the comment

## Step 4: Verify

After all fixes are applied:
1. Run the project's build command to verify compilation (check Makefile, package.json, etc.)
2. If the build fails, diagnose and fix the errors — they're likely caused by incomplete propagation of your changes
3. Report what was fixed and the build result

## Important notes

- These markers are **instructions from the user to you**. They are not regular code TODOs — don't skip them or leave them for later.
- Only act on markers addressed to *you* (or the generic `ai`/`agent`). A `TODO(bob)` is not yours; leave it alone. If you see a marker addressed to a *different* agent (e.g. you are Codex and see `TODO(claude)`), mention it to the user but don't touch it unless they confirm.
- Always propagate changes through all layers (IDL → generated code → model → DAL → service → handler → frontend).
- If a fix requires regenerating code (e.g., `make update-idl`), do it.
- Regular `TODO` and `FIXME` comments (with no handle, or a handle that isn't yours) are NOT your concern — leave them alone.
