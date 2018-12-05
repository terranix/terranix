let

  pkgs = import <nixpkgs> {};
  eval = import ./lib.nix pkgs;

in eval.eval
  {

    imports = [ ./test-module.nix ];
    testModule.enable = true;

    provider = [{ "aws" = "something"; }] ;

    # todo is not merging yet
    # resource = { "aws_iam_user" = { "you" =  "test-user" ; } ; };

  }

