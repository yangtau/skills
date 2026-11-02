{
  description = "Personal agent skills (plus curated upstream skills), exposed as a flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lark-cli = {
      url = "github:larksuite/cli";
      flake = false;
    };
    mattpocock = {
      url = "github:mattpocock/skills";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      lark-cli,
      mattpocock,
    }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

      # Skills from this repository.
      ownSkills = [
        "fix-todos"
        "simplify"
      ];

      # Skills picked from mattpocock/skills (dir relative to repo root; name = basename).
      mattpocockSkills = [
        # call by user
        # "skills/engineering/ask-matt"
        # "skills/engineering/grill-with-docs"
        # "skills/engineering/triage"
        "skills/engineering/improve-codebase-architecture"
        # "skills/engineering/setup-matt-pocock-skills"
        # "skills/engineering/to-spec"
        # "skills/engineering/to-tickets"
        # "skills/engineering/implement"
        # "skills/engineering/wayfinder"

        # "skills/productivity/grill-me"
        "skills/productivity/handoff"
        # "skills/productivity/wait-what"

        # call by model
        # "skills/engineering/prototype"
        # "skills/engineering/diagnosing-bugs"
        # "skills/engineering/research"
        # "skills/engineering/tdd"
        "skills/engineering/domain-modeling"
        "skills/engineering/codebase-design"
        "skills/engineering/retro"
        # "skills/engineering/code-review"
        # "skills/engineering/wizard"

        "skills/productivity/grilling"
        "skills/productivity/writing-for-agents"
      ];

      # lark-cli: every upstream skills/lark-* sub-skill is copied under
      # references/subskills/ of this repo's router (skills/lark-cli).
      # Agent hosts discover nested SKILL.md files as standalone skills, so the
      # sub-skill entry points are renamed to GUIDE.md and references rewritten.
      larkCliSkill =
        pkgs:
        pkgs.runCommand "lark-cli-skill" { } ''
          dest="$out/references/subskills"
          mkdir -p "$dest"
          cp -R ${lark-cli}/skills/lark-*/ "$dest/"
          chmod -R u+w "$dest"
          find "$dest" -name SKILL.md -execdir mv {} GUIDE.md \;
          grep -rl 'SKILL\.md' "$dest" --include='*.md' \
            | xargs -r sed -i 's/SKILL\.md/GUIDE.md/g'
          # plugin-guide lives outside this tree at runtime; its real file name is SKILL.md.
          grep -rl 'plugin-guide/GUIDE\.md' "$dest" --include='*.md' \
            | xargs -r sed -i 's#plugin-guide/GUIDE\.md#plugin-guide/SKILL.md#g'
          cp -R ${self + "/skills/lark-cli"}/. "$out/"
        '';

      mkSkills =
        pkgs:
        nixpkgs.lib.genAttrs ownSkills (name: self + "/skills/${name}")
        // builtins.listToAttrs (
          map (dir: nixpkgs.lib.nameValuePair (baseNameOf dir) (mattpocock + "/${dir}")) mattpocockSkills
        )
        // {
          lark-cli = larkCliSkill pkgs;
        };
    in
    {
      # skills.<system>.<name> = directory whose root contains SKILL.md.
      skills = forAllSystems mkSkills;

      packages = forAllSystems (pkgs: {
        default = pkgs.linkFarm "skills" (self.skills.${pkgs.stdenv.hostPlatform.system});
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);
    };
}
