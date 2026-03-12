# AGENTS.md

Keep changes small and local.

- Use the VS Code task semantics when applying changes:
  `HMS` => `home-manager switch --flake "path:${workspaceFolder}"`
  `NFU` => `nix flake update --flake "${workspaceFolder}"`
- Prefer stable package versions by default unless a module clearly documents a temporary exception.
- Keep `home.stateVersion` conservative; release upgrades should update flake inputs first, not this value.
