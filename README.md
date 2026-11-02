# skills

Personal agent skills, packaged as a Nix flake together with a curated set of upstream skills.

## Skills

Own (in `skills/`):

- `fix-todos` — scan for TODO(<agent>)/FIXME(<agent>) markers and fix them
- `simplify` — quality pass over changed code (reuse, simplification, efficiency)
- `lark-cli` — unified router for all `lark-*` sub-skills of [larksuite/cli](https://github.com/larksuite/cli).
  The router lives in `skills/lark-cli/`; at build time every upstream `skills/lark-*` is copied into
  `references/subskills/`, with nested `SKILL.md` renamed to `GUIDE.md` (and references rewritten) so hosts
  don't discover them as standalone skills.

From [mattpocock/skills](https://github.com/mattpocock/skills): `improve-codebase-architecture`, `handoff`,
`domain-modeling`, `codebase-design`, `retro`, `grilling`, `writing-for-agents`. Other candidates are listed
(commented out) in `flake.nix`.

## Flake outputs

- `skills.<system>` — attrset of skill name → directory (store path or derivation) whose root contains `SKILL.md`.
  Systems: `aarch64-darwin`, `x86_64-darwin`, `x86_64-linux`, `aarch64-linux`.
- `packages.<system>.default` — `linkFarm` of all skills (`nix build` → `result/<name>/SKILL.md`).
- `formatter.<system>` — `nixfmt-tree` (`nix fmt`).

Consumers decide where each skill is installed, e.g.:

```nix
inputs.skills.url = "github:yangtau/skills";
# ...
inputs.skills.skills.${system}.lark-cli
```

## Updating

Upstream sources (`lark-cli`, `mattpocock`, `nixpkgs`) are pinned in `flake.lock`.
`.github/workflows/update.yml` runs daily (and on demand): `nix flake update`, `nix build .#default`,
then commits `flake.lock` to `main` if anything changed. To update manually:

```sh
nix flake update && nix build .#default
```
