
let

pkgs = import <nixpkgs> {};

foo = rec {
  x = "hallo du";
  y = x;
};

result = with pkgs.lib; evalModules {
    modules = [
      { options = {
        provider = mkOption {
          type = types.listOf types.attrs;
        };
        resource = mkOption {
          type = types.attrs;
        };
      };
      }
      { provider = [{ "aws" = "something"; }] ;
        resource = { "aws_iam_user" = "test-user" ; };
      }
      # { provider = [ { "aws" = config.resource."aws_iam_user" ; } ]; }
    ];
    #{
    #  options.peni = {
    #    enable = mkEnableOption "enable name";
    #  };
    #
    #      config = mkIf cfg.enable {
    #        rec { hallo = "du" ; }
    #      };
    #    }
  };

in result

