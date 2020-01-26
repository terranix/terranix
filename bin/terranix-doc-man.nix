# copy from : https://github.com/rycee/home-manager/blob/master/doc/default.nix
# this is just a first sketch to make it work. optimization comes later
{ pkgs, ... }:

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
      [ (import <config> { inherit lib pkgs; config = {}; })]
      ++ [ (import ../modules/default.nix { inherit lib pkgs; config = {}; })]
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
  docs.manPages
