import Config

replacements = [
  %{
    file: "CHANGELOG.md",
    type: :changelog,
    patterns: [
      %{search: "Unreleased", replace: "{{version}}", type: :unreleased},
      %{search: "...HEAD", replace: "...{{tag_name}}", global: false},
      %{search: "ReleaseDate", replace: "{{date}}"},
      %{
        search: "<!-- next-header -->",
        replace: "<!-- next-header -->\n\n## [Unreleased] - ReleaseDate",
        global: false
      },
      %{
        search: "<!-- next-url -->",
        replace:
          "<!-- next-url -->\n[Unreleased]: https://github.com/wois-org/ivcv_ex/compare/{{tag_name}}...HEAD",
        global: false
      }
    ]
  }
]

config :version_release,
  tag_prefix: "v",
  hex_publish: true,
  hex_force_publish: true,
  changelog: %{
    creation: :manual,
    minor_patterns: ["added", "changed", "fixed", "fix"],
    major_patterns: ["breaking"],
    replacements: replacements,
    pre_release_replacements: replacements
  },
  commit_message: "[skip ci][version_release] {{message}}",
  dev_version: true,
  merge: %{
    ignore_conflicts: true,
    branches: [
      %{
        from: "master",
        to: ["develop"],
        strategy: ["recursive", "--strategy-option", "theirs"],
        message: "[skip ci] Merge branch '{{from}}' into {{to}}"
      }
    ]
  }
