{ myConfig, pkgs, ... }:

{
  # Installation of gpg and pinentry
  home.packages = with pkgs; [
    pinentry-qt # Install pinentry qt for GUI, it also contains pinentry-tty and pinentry-curses
  ];

  programs.gpg = {
    enable = true;
    package = pkgs.gnupg;
    settings = {
      default-key = myConfig.user.email;
    };
  };

  # Configure the GPG agent
  services.gpg-agent = {
    enable = true;
    grabKeyboardAndMouse = false; # must be false, or the pinentry will not show up in WSL 2.

    # Force to use a specific pinentry program
    # It is not necessary, the system will choose the best one

    # Available options:
    # Name            | Type
    # ----------------|---------
    # pinentry-qt     | GUI
    # pinentry-tty    | Terminal
    # pinentry-curses | Terminal

    # pinentryPackage = pkgs.pinentry-curses;
  };
}
