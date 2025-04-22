{ lib, pkgs, ... }:

{
  programs.tmux = {
    # Use <prefix> + Shift-r to reload the config
    enable = true;
    package = pkgs.tmux;
    shell = "${pkgs.zsh}/bin/zsh";
    mouse = true; # Enable mouse support
    clock24 = true; # Use 24-hour clock
    terminal = "screen-256color"; # For better compatibility with other terminals
    baseIndex = 1; # Start window and pane indexes at 1
    prefix = "C-x"; # Use Ctrl-x as prefix instead of Ctrl-b
    historyLimit = 50000; # Increase scrollback buffer size from 2000 to 50000 lines
    focusEvents = true; # Focus events enabled for terminals that support them
    aggressiveResize = true; # Super useful when using "grouped sessions" and multi-monitor setup
    escapeTime = 0; # Address vim mode switching delay (http://superuser.com/a/252717/65504)
    sensibleOnTop = true; # Put sensible plugin on top, so we can override some sensible settings

    plugins = with pkgs.tmuxPlugins; [
      # Some quality of life settings
      sensible

      # Use <prefix> + Ctrl‑s to save the current session
      # <prefix> + Ctrl‑r to restore it
      resurrect

      # Restore sessions automatically on startup
      # Requires tmux-resurrect
      {
        plugin = continuum;
        extraConfig = ''
          # Must set this to enable continuum
          set -g @continuum-restore 'on'
        '';
      }

      # Uses a fuzzy finder to search terminal scrollback buffer
      # and jump to selected position. Type <prefix> + ? to start
      fuzzback
    ];

    extraConfig = ''
      # Switch to another session if available when the last window is closed
      set -g detach-on-destroy off

      # Auto renumber windows when a window is closed
      set -g renumber-windows on

      # Theme settings
      # ICONS
      terminal_icon=""
      active_terminal_icon=""
      ssh_icon="󰣀"
      left_edge_icon="󱞸"
      right_edge_icon="󱞴"
      prefix_on_icon="󰠠"
      prefix_off_icon="󰤂"
      paired_icon="⚇"
      sync_icon="⚏"
      mouse_icon="󰍽"
      root_icon="!"
      bell_icon=""
      zoom_icon=""
      last_icon="󰁯"

      # COLOR
      color_white="#E4E4E4"
      color_blue="#00AFFF"
      color_dim_blue="#008BCC"
      color_dim_gray="#303030"
      color_black="#080808"
      color_red="#C04851"

      # STATUS BAR LENGTH LIMITS
      set -g status-right-length 120
      set -g status-left-length 60

      # COMMON STATUS BAR STYLES
      set -g status-style fg=default,bg=default # Default use transparent color
      set -g status-interval 1                  # Update every second

      # LEFT STATUS BAR
      # Format: [left edge icon] [prefix state] [session name]
      set -g status-left " #[fg=$color_white,bold]$left_edge_icon #[fg=$color_blue]#{?client_prefix,$prefix_on_icon,#[dim]$prefix_off_icon} #[bold,nodim]#S "

      # RIGHT STATUS BAR
      # Format: [pairing/sync/mouse] [user{! if root}] on [host] [right edge icon]
      set -g status-right "\
      #[fg=$color_white] #{?session_many_attached,$paired_icon ,}#{?synchronize-panes,$sync_icon ,}#{?mouse,$mouse_icon ,}\
      #[fg=$color_red]#{user}#{?#{==:#{user},root},$root_icon,} #[fg=$color_white]on #[fg=$color_red]#H #[fg=$color_white]$right_edge_icon"

      # WINDOW STATUS (FOCUSED)
      # Format: same but bold and color-inverted
      set -g window-status-current-format "#[fg=$color_black,bg=$color_blue,bold] #{?#{==:#{pane_current_command},ssh},$ssh_icon,$active_terminal_icon} #W#{?window_zoomed_flag, $zoom_icon,}#{?window_bell_flag, $bell_icon,} "

      # WINDOW STATUS (UNFOCUSED)
      # Format: [icon] [window name] [optional flags: bell/zoom/last]
      set -g window-status-format "#[fg=$color_dim_blue,bg=$color_dim_gray,nobold] #{?#{==:#{pane_current_command},ssh},$ssh_icon,$terminal_icon} #W#{?window_zoomed_flag, $zoom_icon,}#{?window_bell_flag, $bell_icon,}#{?window_last_flag, $last_icon,} "

      # PANE BORDER STYLES
      set -g pane-border-style fg=$color_dim_gray
      set -g pane-active-border-style fg=$color_blue

      # TERMINAL TITLE
      set -g set-titles on
      set -g set-titles-string "#H ❐ #S ● #I #W"
    '';
  };

  programs.zsh.initContent = lib.mkBefore ''
    # Auto start tmux unless already inside or in VS Code
    [[ -z $TMUX && $TERM_PROGRAM != vscode ]] && exec tmux new -As "main"
  '';
}
