# copy from : https://github.com/rycee/home-manager/blob/master/doc/default.nix
{ pkgs }:

let

  lib = pkgs.lib;

  nmdSrc = pkgs.fetchFromGitLab {
    name = "nmd";
    owner = "rycee";
    repo = "nmd";
    rev = "527245ff605bde88c2dd2ddae21c6479bb7cf8aa";
    sha256 = "sha256-l2KsnY537mz0blZdqALZKrWXn9PD39CpvotgPnxyIP4=";
  };

  nmd = import nmdSrc { inherit pkgs; };

  # Make sure the used package is scrubbed to avoid actually
  # instantiating derivations.
  scrubbedPkgsModule = {
    imports = [
      {
        _module.args = {
          pkgs = lib.mkForce (nmd.scrubDerivations "pkgs" pkgs);
          pkgs_i686 = lib.mkForce { };
        };
      }
    ];
  };

  hmModulesDocs = nmd.buildModulesDocs {
    modules =
      [
        (import ../core/terraform-options.nix {
          inherit lib pkgs;
          config = { };
        })
        (import ../modules/default.nix { inherit lib pkgs; })
      ]
      ++ [ scrubbedPkgsModule ];
    moduleRootPaths = [ ./.. ];
    mkModuleUrl = path:
      "https://github.com/mrVanDalo/terranix/blob/master/${path}#blob-path";
    channelName = "terranix";
    docBook.id = "terranix-options";
  };

  docs = nmd.buildDocBookDocs {
    pathName = "terranix";
    modulesDocs = [ hmModulesDocs ];
    documentsDirectory = ./.;
    chunkToc = ''
      <toc>
        <d:tocentry xmlns:d="http://docbook.org/ns/docbook" linkend="book-terranix-manual"><?dbhtml filename="index.html"?>
          <d:tocentry linkend="ch-options"><?dbhtml filename="options.html"?></d:tocentry>
          <d:tocentry linkend="ch-tools"><?dbhtml filename="tools.html"?></d:tocentry>
          <d:tocentry linkend="ch-release-notes"><?dbhtml filename="release-notes.html"?></d:tocentry>
        </d:tocentry>
      </toc>
    '';
  };

in

{
  #json = hmModulesDocs.json;
  manPages = docs.manPages;
}
