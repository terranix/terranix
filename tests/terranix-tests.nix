[
  {
    text = "backend : setting a backend";
    file = ./terranix-tests/01.nix;
    outputFile = ./terranix-tests/01.nix.output;
  }
  {
    text = "backend : setting 2 terranixs will fail";
    file = ./terranix-tests/02.nix;
    success = false;
    outputFile = ./terranix-tests/02.nix.output;
    partialMatchOutput = true;
  }
  {
    text = "remote_state : 2 remote states with the same names are forbidden";
    file = ./terranix-tests/03.nix;
    success = false;
    outputFile = ./terranix-tests/03.nix.output;
    partialMatchOutput = true;
  }
  {
    text = "remote_state : 2 remote states with differente names are ok";
    file = ./terranix-tests/04.nix;
    outputFile = ./terranix-tests/04.nix.output;
  }
  {
    text = "assert : don't trigger error on true mkAssert";
    file = ./terranix-tests/05.nix;
    outputFile = ./terranix-tests/05.nix.output;
  }
  {
    text = "assert : trigger error on false mkAssert";
    file = ./terranix-tests/06.nix;
    success = false;
    outputFile = ./terranix-tests/06.nix.output;
    partialMatchOutput = true;
  }
  {
    text = "strip-nulls: print no nulls without --with-nulls";
    file = ./terranix-tests/07.nix;
    outputFile = ./terranix-tests/07.nix.output;
  }
  {
    text = "strip-nulls: print nulls with --with-nulls";
    options = [ "--with-nulls" ];
    file = ./terranix-tests/07.nix;
    outputFile = ./terranix-tests/07-nulls.nix.output;
  }
  {
    text = "magic-merge: works for attrs and lists";
    file = ./terranix-tests/08-magic-merge.nix;
    outputFile = ./terranix-tests/08-magic-merge.nix.output;
  }
  {
    text = "magic-merge: fails for setting different types";
    file = ./terranix-tests/09-magic-merge-fail.nix;
    success = false;
  }
  {
    text = "magic-merge: leave empty sets untouched";
    file = ./terranix-tests/10-empty-sets.nix;
    outputFile = ./terranix-tests/10-empty-sets.nix.output;
  }
  {
    text = "empty resources: should be filtered out";
    file = ./terranix-tests/11.nix;
    outputFile = ./terranix-tests/11.nix.output;
  }
  {
    text = "terranix lib: tfRef should be available and properly return a reference";
    file = ./terranix-tests/12.nix;
    outputFile = ./terranix-tests/12.nix.output;
  }
  {
    text = "references: should properly reference references and data from config";
    file = ./terranix-tests/13.nix;
    outputFile = ./terranix-tests/13.nix.output;
  }
  {
    text = "terranix lib: tf.ref.template should be available and properly return a templatefile() invocation";
    file = ./terranix-tests/14.nix;
    outputFile = ./terranix-tests/14.nix.output;
  }
  {
    text = "terranix lib: tf.ref.file should be available and properly return a file() invocation";
    file = ./terranix-tests/15.nix;
    outputFile = ./terranix-tests/15.nix.output;
  }
  {
    text = "meta: allow _meta passthru without affecting json";
    file = ./terranix-tests/15-meta.nix;
    outputFile = ./terranix-tests/15-meta.nix.output;
  }
]
