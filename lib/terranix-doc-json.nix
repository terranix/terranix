# copy from : https://github.com/rycee/home-manager/blob/master/doc/default.nix
# this is just a first sketch to make it work. optimization comes later
{ pkgs, arguments, terranix_modules ? [], ... }:

let

  lib = pkgs.lib;

  nmdSrc = pkgs.fetchFromGitLab {
    name = "nmd";
    owner = "rycee";
    repo = "nmd";
    rev = "9751ca5ef6eb2ef27470010208d4c0a20e89443d";
    sha256 = "0rbx10n8kk0bvp1nl5c8q79lz1w0p1b8103asbvwps3gmqd070hi";
  };

  nmd = import nmdSrc { inherit pkgs; };

  # Make sure the used package is scrubbed to avoid actually
  # instantiating derivations.
  scrubbedPkgsModule = {
    imports = [{
      _module.args = {
        pkgs = lib.mkForce (nmd.scrubDerivations "pkgs" pkgs);
        pkgs_i686 = lib.mkForce { };
      };
    }];
  };

  modulesDocs =
    { path ? "/", urlPrefix ? "http://example.com/", urlSuffix ? "", }:
    nmd.buildModulesDocs {
      modules = terranix_modules ++ [
        #(import <config> {
        #  inherit lib pkgs;
        #  config = { };
        #})
        (import ../core/terraform-options.nix {
          inherit lib pkgs;
          config = { };
        })
      ] ++ [ scrubbedPkgsModule ];
      moduleRootPaths = [ path ];
      mkModuleUrl = path: "${urlPrefix}${path}${urlSuffix}";
      channelName = "";
      docBook.id = "terranix-options";
    };

in (modulesDocs arguments).json
