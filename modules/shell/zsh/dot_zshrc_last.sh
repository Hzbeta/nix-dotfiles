# For autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#757575,underline"

# Set preview style for enhancd
export ENHANCD_FILTER="fzf --preview '
eza -al --tree --level 1 --group-directories-first --git-ignore --header --git --icons=auto \
--color=always --hyperlink --no-user --no-time --no-filesize --no-permissions {}' \
--preview-window=right,50% --height=50% --reverse --ansi"

# Set cursor style for zsh
echo -ne '\e[6 q' # Bar steady cursor

# A function to set zsh as the default shell
set_nix_zsh_as_default() {
  local zsh_path
  nix_zsh_path="$(which zsh)"

  # Check if the resolved path is from /nix/store, which is not stable
  if [[ "$nix_zsh_path" == *"/nix/store/"* ]]; then
    echo "❌ The resolved zsh path is located in the Nix store:"
    echo "    $nix_zsh_path"
    echo "⚠️  This path is not suitable for setting as the default shell"
    echo "    because Nix store paths are versioned and may change after updates."
    echo "    The current result is from 'which zsh', which is no longer reliable."
    return 1
  fi

  # Compare the real path of the current shell with the real path of zsh
  local real_nix_zsh_path
  real_nix_zsh_path="$(readlink -f "$nix_zsh_path")"
  local real_default_shell_path
  real_default_shell_path="$(readlink -f "$SHELL")"

  if [[ "$real_default_shell_path" == "$real_nix_zsh_path" ]]; then
    echo "✅ zsh is already the default shell."
    return 0
  fi

  # Ensure the resolved zsh path is present in /etc/shells
  if ! grep -Fxq "$nix_zsh_path" /etc/shells; then
    echo "🔧 Adding $nix_zsh_path to /etc/shells"
    echo "$nix_zsh_path" | sudo tee -a /etc/shells > /dev/null
  else
    echo "ℹ️ $nix_zsh_path already exists in /etc/shells"
  fi

  # Set zsh as the default shell using the stable symlink path
  echo "🔁 Changing default shell to $nix_zsh_path"
  sudo usermod -s "$nix_zsh_path" "$USER"
}
