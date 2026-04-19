{
  config,
  lib,
  pkgs,
  hermesAgent,
  ...
}:

let
  homeDir = config.home.homeDirectory;
  hermesHome = "${homeDir}/.hermes";
  hermesManagedRoot = "${homeDir}/.local/share/rulesync/hermes";
  hermesManagedSkills = "${hermesManagedRoot}/skills";
  hermesPackage = hermesAgent.packages.${pkgs.stdenv.hostPlatform.system}.default;
  hermesCli = "${hermesPackage}/bin/hermes";
  hermesTerminalBackend = "local";
  hermesTerminalTimeout = 300;
  hermesPersistentShell = true;
  hermesSeedConfig = pkgs.writeText "hermes-config.yaml" (
    lib.generators.toYAML { } {
      skills.external_dirs = hermesManagedSkills;
      terminal = {
        backend = hermesTerminalBackend;
        timeout = hermesTerminalTimeout;
        persistent_shell = hermesPersistentShell;
      };
    }
  );
in
{
  home.packages = [ hermesPackage ];

  home.sessionVariables = {
    HERMES_HOME = hermesHome;
  };

  home.activation.hermesManagedSetup = lib.hm.dag.entryAfter [ "installPackages" ] ''

    $DRY_RUN_CMD mkdir -p '${hermesHome}'
    $DRY_RUN_CMD mkdir -p '${hermesManagedRoot}'
    $DRY_RUN_CMD mkdir -p '${hermesManagedSkills}'

    if [ ! -f '${hermesHome}/config.yaml' ]; then
      $DRY_RUN_CMD install -m 600 '${hermesSeedConfig}' '${hermesHome}/config.yaml'
    fi

    $DRY_RUN_CMD env HERMES_HOME='${hermesHome}' '${hermesCli}' config set terminal.backend '${hermesTerminalBackend}'
    $DRY_RUN_CMD env HERMES_HOME='${hermesHome}' '${hermesCli}' config set terminal.timeout '${toString hermesTerminalTimeout}'
    $DRY_RUN_CMD env HERMES_HOME='${hermesHome}' '${hermesCli}' config set terminal.persistent_shell '${lib.boolToString hermesPersistentShell}'
    $DRY_RUN_CMD env HERMES_HOME='${hermesHome}' '${hermesCli}' config set skills.external_dirs '${hermesManagedSkills}'

    linger_state="$(loginctl show-user "$USER" -p Linger --value 2>/dev/null || true)"
    if [ "$linger_state" != "yes" ]; then
      printf '%s\n' 'Run once to keep Hermes gateway alive after WSL session exit:'
      printf '%s\n' '  sudo loginctl enable-linger "$USER"'
    fi

    $DRY_RUN_CMD env HERMES_HOME='${hermesHome}' '${hermesCli}' gateway install --force
    $DRY_RUN_CMD env HERMES_HOME='${hermesHome}' '${hermesCli}' gateway start
  '';
}
