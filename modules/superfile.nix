{
  lib,
  pkgsUnstable,
  ...
}:

let
  # `spf` is the shell entrypoint that restores the last directory on quit.
  # Plain `superfile` cannot change the parent shell directory.
  superfileWrapper = ''
    spf() {
      local lastdir_path="''${XDG_STATE_HOME:-$HOME/.local/state}/superfile/lastdir"
      command superfile "$@"
      if [ -f "$lastdir_path" ]; then
        . "$lastdir_path"
        rm -f -- "$lastdir_path" >/dev/null 2>&1
      fi
    }
  '';
in

{
  programs.superfile = {
    enable = true;
    # Use unstable temporarily because the stable 25.11 package is behind upstream.
    # TODO: Switch back to pkgs.superfile when nixos-26.05 ships a new enough release.
    package = pkgsUnstable.superfile;
    settings = {
      theme = "catppuccin-frappe";
      editor = "";
      dir_editor = "";
      auto_check_update = true;
      cd_on_quit = true;
      default_open_file_preview = true;
      show_image_preview = true;
      show_panel_footer_info = true;
      default_directory = ".";
      file_size_use_si = false;
      default_sort_type = 0;
      sort_order_reversed = false;
      case_sensitive_sort = false;
      shell_close_on_success = false;
      debug = false;
      ignore_missing_fields = false;
      nerdfont = true;
      transparent_background = true;
      # Keep this enabled so the border appears automatically once the packaged
      # superfile release supports preview-panel borders.
      enable_file_preview_border = true;
      file_preview_width = 0;
      code_previewer = "";
      sidebar_width = 20;
      border_top = "─";
      border_bottom = "─";
      border_left = "│";
      border_right = "│";
      border_top_left = "╭";
      border_top_right = "╮";
      border_bottom_left = "╰";
      border_bottom_right = "╯";
      border_middle_left = "├";
      border_middle_right = "┤";
      metadata = false;
      enable_md5_checksum = false;
      zoxide_support = false;
    };
  };
  # Keep the wrapper colocated with the superfile module instead of generic shell modules.
  programs.zsh.initContent = lib.mkAfter superfileWrapper;
  programs.bash.bashrcExtra = superfileWrapper;
}
