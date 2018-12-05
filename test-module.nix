{ config, lib, ... }:

with lib;

let

  cfg = config.testModule;

in {

  options.testModule = {
    enable = mkEnableOption "enable test module";
  };

   config = mkIf cfg.enable {
    resource = { "aws_iam_user" = {
      I = "am a test-module which should be visible";
    };
  };
  };
}
