{ pkgs, config, lib, ... }:
with lib;
let cfg = config.servers.grafana;
in {

  options.servers.grafana = {
    enable = mkEnableOption "grafana service";
    name = mkOption {
      default = "grafana-server";
      type = with types; str;
      description = ''
        name
      '';
    };
    plugins = mkOption {
      default = [ "grafana-clock-panel" "grafana-simple-json-datasource" ];
      type = with types; listOf str;
      description = ''
        list of plugins which should be installed
      '';
    };
  };

  config = mkIf cfg.enable {
    hcloud.server."${cfg.name}" = {
      enable = true;
      provisioners = [{
        remote-exec.inline = [
          "sleep 60" # ugly hack because of apt locking
          "apt update"
          "apt -y install docker.io"
          ''
            docker run -d --name=grafana \
                          ${
                            optionalString (cfg.plugins != [ ])
                            "-e GF_INSTALL_PLUGINS=${
                              concatStringsSep "," cfg.plugins
                            }"
                          } \
                          -p 80:3000 \
                          grafana/grafana
                      ''
        ];
      }];
    };
  };
}
