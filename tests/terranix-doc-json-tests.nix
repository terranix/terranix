[
  {
    text = "terranix-doc-json: works with simple module";
    path = ./terranix-doc-json-tests;
    file = "${./terranix-doc-json-tests}/01.nix";
    outputFile = ./terranix-doc-json-tests/01.nix.output;
  }

  {
    text = "terranix-doc-json: works with empty module";
    file = ./terranix-doc-json-tests/02.nix;
    outputFile = ./terranix-doc-json-tests/02.nix.output;
  }
]
