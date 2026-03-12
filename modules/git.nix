{ myConfig, pkgs, ... }:

let
  gitSshWrapper = pkgs.writeShellScriptBin "git-ssh-wrapper" ''
    if [ -n "''${WSL_DISTRO_NAME-}" ] || [ -n "''${WSL_INTEROP-}" ]; then
      windows_ssh="$(command -v ssh.exe 2>/dev/null || true)"
      if [ -n "$windows_ssh" ] && [ -x "$windows_ssh" ]; then
        exec "$windows_ssh" "$@"
      fi
    fi

    exec ${pkgs.openssh}/bin/ssh "$@"
  '';
in

{
  programs.git = {
    enable = true;
    # We can use the unstable version of git if we want to.
    # package = pkgsUnstable.git;
    package = pkgs.git;
    signing = {
      key = myConfig.user.gpgSigningKey;
      signByDefault = true;
    };
    settings = {
      user = {
        name = myConfig.user.gitName;
        email = myConfig.user.email;
      };
      # In WSL, prefer the Windows OpenSSH client so Git can reuse the external
      # KeePassXC-managed SSH agent. Fall back to Linux OpenSSH elsewhere.
      core.sshCommand = "${gitSshWrapper}/bin/git-ssh-wrapper";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
