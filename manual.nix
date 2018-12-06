{ pkgs ?  import <nixpkgs> {} }:

with pkgs.lib;

let
   config = { meta = { doc = [] ; } ; };
   mkManual = modList: import <nixpkgs/nixos/doc/manual> rec {
    inherit pkgs config;
    #inherit pkgs;
    # version = config.system.nixos.release;
    version = "10";
    revision = "release-${version}";
    options = let
      scrubbedEval = evalModules {
        # modules = [ { nixpkgs.localSystem = config.nixpkgs.localSystem; } ] ++ (import <helsinki/3modules>) ++ modList;
        modules = modList;
        # args = (config._module.args) // { modules = [ ]; };
        specialArgs = { pkgs = scrubDerivations "pkgs" pkgs; };
      };
      scrubDerivations = namePrefix: pkgSet: mapAttrs
        (name: value:
          let wholeName = "${namePrefix}.${name}"; in
          if isAttrs value then
            scrubDerivations wholeName value
            // (optionalAttrs (isDerivation value) { outPath = "\${${wholeName}}"; })
          else value
        )
        pkgSet;
      in scrubbedEval.options;
  };

in pkgs.mkShell {

  # needed pkgs
  # -----------
  buildInputs = with pkgs; [
    ((mkManual [
                ./core/modules/cloudflare/default.nix
                #./core/modules/cloudflare/provider.nix
                ./core/modules/hetzner/default.nix
                #./core/modules/hetzner/provider.nix
                #./core/modules/hetzner/server.nix
                #./core/modules/hetzner/volume.nix
              ]).manpages)
  ];

  # run this on start
  # -----------------
  shellHook = ''

  HISTFILE=${toString ./.}/.history

  '';
}
