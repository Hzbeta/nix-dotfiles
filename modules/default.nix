{
  imports = [
    ./shell # Modules for shell configuration
    ./git.nix # A source control system
    ./ssh.nix # SSH client
    ./gpg.nix # For signing commits
    ./tmux.nix # A terminal multiplexer, powerful for remote sessions
    ./fd.nix # A simple and fast alternative to find
    ./btop.nix # A powerful and easy-to-use system monitor
    ./bat.nix # A cat clone with syntax highlighting and Git integration
    ./fzf.nix # A command-line fuzzy finder
    ./eza.nix # A modern replacement for ls
    ./yazi.nix # A powerful file explorer
  ];
}
