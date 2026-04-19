{ pkgs, ... }:

{
  home.packages = [ pkgs.uv ];

  home.file.".config/uv/uv.toml".text = ''
    exclude-newer = "7 days"
  '';
}
