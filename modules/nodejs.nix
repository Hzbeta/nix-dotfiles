{
  config,
  lib,
  pkgs,
  ...
}:

let
  homeDir = config.home.homeDirectory;
  npmGlobalPrefix = "${homeDir}/.local/share/npm-global";
  npmGlobalBin = "${npmGlobalPrefix}/bin";
  agentBrowserCli = pkgs.writeShellScriptBin "agent-browser" ''
    exec '${npmGlobalBin}/agent-browser' "$@"
  '';
  agentBrowserBrowsersDir = "${homeDir}/.agent-browser/browsers";
in

{
  home.packages = [ pkgs.nodejs agentBrowserCli ];

  home.file.".npmrc".text = ''
    prefix=${npmGlobalPrefix}
    min-release-age=7
  '';

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = npmGlobalPrefix;
  };

  home.activation.agentBrowserInstall = lib.hm.dag.entryAfter [ "installPackages" ] ''
    export HOME='${homeDir}'
    export PATH="${pkgs.nodejs}/bin:$PATH"
    export NPM_CONFIG_USERCONFIG='${homeDir}/.npmrc'
    export NPM_CONFIG_PREFIX='${npmGlobalPrefix}'

    $DRY_RUN_CMD '${pkgs.coreutils}/bin/mkdir' -p '${npmGlobalPrefix}'

    if [ ! -x '${npmGlobalBin}/agent-browser' ]; then
      $DRY_RUN_CMD '${pkgs.nodejs}/bin/npm' install -g --prefix '${npmGlobalPrefix}' agent-browser@latest
    fi

    if ! ls '${agentBrowserBrowsersDir}'/chrome-* >/dev/null 2>&1; then
      $DRY_RUN_CMD '${npmGlobalBin}/agent-browser' install
    fi
  '';
}
