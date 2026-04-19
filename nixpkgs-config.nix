rec {
  packages = [
    { name = "ffmpeg"; stable = true; free = true; } # A complete solution to record, convert, and stream audio and video.
    { name = "gh"; stable = true; free = true; } # GitHub CLI.
    # { name = "github-copilot-cli"; stable = true; free = false; } # GitHub Copilot CLI.
    { name = "nixfmt-rfc-style"; stable = true; free = true; } # A tool to format Nix code.
    { name = "dust"; stable = true; free = true; } # du + rust = dust. Like du but more intuitive.
    { name = "duf"; stable = true; free = true; } # Disk Usage/Free Utility. A better du.
    { name = "jq"; stable = true; free = true; } # A lightweight and flexible command-line JSON processor.
    { name = "ripgrep"; stable = true; free = true; } # Fast recursive search tool.
    { name = "unzip"; stable = true; free = true; } # A utility to unpack zip files.
    { name = "wget"; stable = true; free = true; } # Command-line downloader.
  ];

  homePackages = {
    stable = map (pkg: pkg.name) (builtins.filter (pkg: pkg.stable) packages);
    unstable = map (pkg: pkg.name) (builtins.filter (pkg: !pkg.stable) packages);
  };

  allowUnfree = map (pkg: pkg.name) (builtins.filter (pkg: !pkg.free) packages);
}
