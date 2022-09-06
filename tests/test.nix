{ pkgs, lib, terranix, ... }:


with lib; [

  ''
    @test "backend : setting a backend" {
    run ${terranix}/bin/terranix --quiet ${./terranix-tests/01.nix}
    assert_success
    assert_output ${escapeShellArg (fileContents ./terranix-tests/01.nix.output)}
    }

    @test "backend : setting 2 terranixs will fail" {
    run ${terranix}/bin/terranix --quiet ${./terranix-tests/02.nix}
    assert_failure
    assert_output ${escapeShellArg (fileContents ./terranix-tests/02.nix.output)}
    }
  ''

  ''
    @test "remote_state : 2 remote states with the same names are forbidden" {
    run ${terranix}/bin/terranix --quiet ${./terranix-tests/03.nix}
    assert_failure
    assert_output ${escapeShellArg (fileContents ./terranix-tests/03.nix.output)}
    }

    @test "remote_state : 2 remote states with differente names are ok" {
    run ${terranix}/bin/terranix --quiet ${./terranix-tests/04.nix}
    assert_success
    assert_output ${escapeShellArg (fileContents ./terranix-tests/04.nix.output)}
    }
  ''

  ''
    @test "assert : don't trigger error on true mkAssert " {
    run ${terranix}/bin/terranix --quiet ${./terranix-tests/05.nix}
    assert_success
    assert_output ${escapeShellArg (fileContents ./terranix-tests/05.nix.output)}
    }

    @test "assert : trigger error on false mkAssert " {
    run ${terranix}/bin/terranix --quiet ${./terranix-tests/06.nix}
    assert_failure
    assert_output ${escapeShellArg (fileContents ./terranix-tests/06.nix.output)}
    }
  ''

  ''
    @test "strip-nulls: print no nulls without --with-nulls" {
    run ${terranix}/bin/terranix --quiet ${./terranix-tests/07.nix}
    assert_success
    assert_output ${escapeShellArg (fileContents ./terranix-tests/07.nix.output)}
    }

    @test "strip-nulls: print nulls with --with-nulls" {
    run ${terranix}/bin/terranix --with-nulls --quiet ${./terranix-tests/07.nix}
    assert_success
    assert_output  ${escapeShellArg (fileContents ./terranix-tests/07-nulls.nix.output)}
    }
  ''

  ''
    @test "magic-merge: works for attrs and lists" {
    run ${terranix}/bin/terranix --quiet ${./terranix-tests/08-magic-merge.nix}
    assert_success
    assert_output ${escapeShellArg (fileContents ./terranix-tests/08-magic-merge.nix.output)}
    }

    @test "magic-merge: fails for setting different types" {
    run ${terranix}/bin/terranix --quiet ${./terranix-tests/09-magic-merge-fail.nix}
    assert_failure
    }

    @test "magic-merge: leave empty sets untouched" {
    run ${terranix}/bin/terranix --quiet ${./terranix-tests/10-empty-sets.nix}
    assert_success
    assert_output ${escapeShellArg (fileContents ./terranix-tests/10-empty-sets.nix.output)}
    }
  ''

  ''
    @test "empty resources: should be filtered out" {
    run ${terranix}/bin/terranix --quiet ${./terranix-tests/11.nix}
    assert_success
    assert_output ${escapeShellArg (fileContents ./terranix-tests/11.nix.output)}
    }
  ''

  ''
    @test "terranix-doc-json: works with simple module" {
    run ${terranix}/bin/terranix-doc-json --quiet \
    --path ${./terranix-doc-json-tests} \
      ${./terranix-doc-json-tests}/01.nix
    assert_success
    assert_output ${escapeShellArg (fileContents ./terranix-doc-json-tests/01.nix.output)}
    }

    @test "terranix-doc-json: works with empty module" {
    run ${terranix}/bin/terranix-doc-json --quiet ${./terranix-doc-json-tests/02.nix}
    assert_success
    assert_output ${escapeShellArg (fileContents ./terranix-doc-json-tests/02.nix.output)}
    }
  ''

]
