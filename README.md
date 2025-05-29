# Nix Dotfiles

> **One flake, reproducible everywhere.**
> Declarative, version‑controlled config for my Linux workstations, powered by **Nix + Home‑Manager**.

## Quick Look

<p align="center">
  <img src="https://raw.githubusercontent.com/hzbeta/nix-dotfiles/main/assets/terminal.png" alt="Terminal screenshot" width="800"/>
</p>

## Featured Configs

| Configs | Highlights                                                                |
| ------- | ------------------------------------------------------------------------- |
| `Zsh`   | Antidote‑managed Zsh, FZF UX, autosuggestions, Oh‑My‑Posh prompt          |
| `Tmux`  | Ctrl‑x prefix, mouse, 24h clock, large scrollback, resurrect, sleek theme |

## Blueprint – One Tree to Rule Them All

```text
.
├─ flake.nix            ──▷ flake entrypoint (inputs / outputs)
├─ flake.lock           ──▷ pinned nixpkgs & HM revisions
├─ home.nix             ──▷ Home‑Manager options & packages
├─ my-config.nix        ──▷ personal constants
├─ .vscode/
│  └─ tasks.json        ──▷ VS Code shortcuts: switch / update
└─ modules/             ──▷ each tool lives in its own module
   ├─ git.nix           ──▷ git prefs + commit signing
   ├─ gpg.nix           ──▷ GPG agent & pinentry
   ├─ tmux.nix          ──▷ hotkeys, plugins, nerd‑font status bar
   ├─ yazi.nix          ──▷ `yy` wrapper + preview deps
   ├─ eza.nix           ──▷ colourful `ls` defaults
   ├─ bat.nix           ──▷ syntax‑highlighted `cat`
   ├─ fd.nix            ──▷ fast, friendly `find`
   ├─ fzf.nix           ──▷ fuzzy finder everywhere
   ├─ btop.nix          ──▷ minimalist system monitor skin
   ├─ ssh.nix           ──▷ OpenSSH client package
   └─ shell/
      ├─ shell-common.nix     ─▷ shared aliases (`hms`, `nfu`, …)
      ├─ bash.nix             ─▷ conservative fallback shell
      ├─ zsh/
      │  ├─ zsh.nix           ─▷ Antidote plugins + Oh‑My‑Posh glue
      │  └─ dot_zshrc_last.sh ─▷ settings and set_default function
      └─ oh-my-posh/
         ├─ oh-my-posh.nix    ─▷ export columns to engine
         └─ config.toml       ─▷ two‑line nerd‑font theme
```

## Configuration Details

> **Tip:** Keep **Nerd Fonts** installed system‑wide to see all icons. Without them, the layout is still usable—icons fall back to plain text.

---

### Zsh + Oh‑My‑Posh

This configuration uses **Antidote** to manage Zsh plugins:

| Plugin                                       | Description                              |
| -------------------------------------------- | ---------------------------------------- |
| `getantidote/use-omz`                        | Loads Oh‑My‑Zsh in the correct order     |
| `zsh-users/zsh-completions`                  | Hundreds of extra completions            |
| `mattmc3/ez-compinit`                        | Batches `compinit`, cutting startup time |
| `Aloxaf/fzf-tab`                             | FZF‑powered tab‑completion everywhere    |
| `zsh-users/zsh-autosuggestions`              | Inline history suggestions               |
| `zdharma-continuum/fast-syntax-highlighting` | Native‑speed syntax colors               |
| `b4b4r07/enhancd`                            | Fuzzy `cd` with tree preview             |
| `joshskidmore/zsh-fzf-history-search`        | Rich Ctrl‑R history search               |
| `ohmyzsh/plugins/extract`                    | Universal `extract` function             |
| `ohmyzsh/plugins/sudo`                       | Double‑ESC to prepend `sudo`             |
| `ohmyzsh/plugins/command-not-found`          | Smart package hints                      |

Additional tweaks live in `dot_zshrc_last.sh`:

| Setting                           | Purpose                                              |
| --------------------------------- | ---------------------------------------------------- |
| `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE` | Clearer suggestion color                             |
| `ENHANCD_FILTER`                  | Fancy `fzf` + `eza` previews                         |
| `set_nix_zsh_as_default()`        | Makes Nix‑supplied Zsh your login shell on non‑NixOS |

`Oh‑My‑Posh` renders a two‑line prompt with transient cleaning and dynamic truncation (25% path length in Git repos, 50% elsewhere) using a `PreGit` segment.

---

### Tmux – Reloadable, Icon‑Themed Multiplexer

A single `programs.tmux` module in `tmux.nix` file drives an opinionated setup that feels the same everywhere the flake is activated.

| Feature                | Implementation                                                                                                     |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------ |
| Quick reload           | `prefix + Shift‑r` sources the file instantly via `tmux source‑file`                                               |
| Ergonomic prefix       | `Ctrl‑x` replaces the default `Ctrl‑b` so your fingers stay on home row                                            |
| Massive scrollback     | `historyLimit = 50000` keeps weeks of output; search it with the `tmux-fuzzback` plugin (`prefix + ?`)             |
| Mouse + focus          | Full mouse interaction and terminal focus events enabled                                                           |
| Session persistence    | `resurrect` saves with `prefix + Ctrl‑s`, restores with `prefix + Ctrl‑r`; `continuum` auto‑restores on startup    |
| Smart window numbering | `renumber-windows on` keeps indexes compact; closing the last window hops to the next session instead of detaching |
| Unicode icon theme     | Dozens of Nerd‑Font glyphs indicate prefix mode, sync, pairing, SSH panes, zoom, bells and more                    |
| Color palette          | Bright blue accents on a dim‑gray bar with white text; active pane borders also blue                               |
| Title string           | Terminal titles become `host ❐ session ● index window`                                                             |
| Auto‑attach            | The Zsh `initContent` block runs `tmux new -As main` unless already inside tmux or VS Code                         |

#### Status bar design

* **Left**: edge glyph, live prefix state, session name
* **Right**: sync/pair/mouse flags, `user!` (root marked), `host`
* **Focused window**: inverted colors, terminal/SSH icon, zoom/bell markers

A minimal theme file provides the glyph variables so the configuration can be re‑used on monospace or patched‐font hosts without edits.

## Getting Started

### Step 1 – Prepare Your Environment

* Install a Nerd Font for full icon support.
* Install nix with: `curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate --no-confirm`
* Restart your terminal to activate nix commands

### Step 2 – Fork the Repository and Edit

* Fork this repository to your own GitHub account.
* Change the `my-config.nix` file to include your personal details, such as your name, email, and any other custom settings you want to apply.
* Clone your forked repository with: `nix run nixpkgs#git clone <your-repo-url> ~/.config/home-manager`.

### Step 3 – Activate

* Activate the configuration by running: `nix run nixpkgs#home-manager -- switch -b home-manager-backup --flake ~/.config/home-manager`
* Home‑Manager will install itself and apply the configuration, you don't need to install it separately.
* The `-b` flag backs up existing files (e.g., `.bashrc`) with a `.home-manager-backup` suffix during the first `switch`.
* The `-b` option is only needed during the first `switch`. For subsequent configuration changes, simply run `hms`, which is an alias defined in `shell-common.nix`.
* Switch to `zsh` and use `set_nix_zsh_as_default` to make `zsh` your default shell.
