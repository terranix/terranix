{ pkgs, lib, terranix, ... }:
with lib; [

  ''
    @test "backend : setting a backend" {
    run ${terranix}/bin/terranix --quiet ${./backend-tests/01.nix}
    [ "$status" -eq 0 ]
    [ "$output" =  ${
      escapeShellArg (fileContents ./backend-tests/01.nix.output)
    } ]
    }

    @test "backend : setting 2 backends will fail" {
    run ${terranix}/bin/terranix --quiet ${./backend-tests/02.nix}
    [ "$status" -ne 0 ]
    [ "$output" =  ${
      escapeShellArg (fileContents ./backend-tests/02.nix.output)
    } ]
    }
  ''

  ''
    @test "remote_state : 2 remote states with the same names are forbidden" {
    run ${terranix}/bin/terranix --quiet ${./backend-tests/03.nix}
    [ "$status" -ne 0 ]
    [ "$output" =  ${
      escapeShellArg (fileContents ./backend-tests/03.nix.output)
    } ]
    }

    @test "remote_state : 2 remote states with differente names are ok" {
    run ${terranix}/bin/terranix --quiet ${./backend-tests/04.nix}
    [ "$status" -eq 0 ]
    [ "$output" =  ${
      escapeShellArg (fileContents ./backend-tests/04.nix.output)
    } ]
    }
  ''

  ''
    @test "assert : don't trigger error on true mkAssert " {
    run ${terranix}/bin/terranix --quiet ${./backend-tests/05.nix}
    [ "$status" -eq 0 ]
    [ "$output" =  ${
      escapeShellArg (fileContents ./backend-tests/05.nix.output)
    } ]
    }

    @test "assert : trigger error on false mkAssert " {
    run ${terranix}/bin/terranix --quiet ${./backend-tests/06.nix}
    [ "$status" -ne 0 ]
    [ "$output" =  ${
      escapeShellArg (fileContents ./backend-tests/06.nix.output)
    } ]
    }
  ''

  ''
    @test "strip-nulls: print no nulls without --with-nulls" {
    run ${terranix}/bin/terranix --quiet ${./backend-tests/07.nix}
    [ "$status" -eq 0 ]
    [ "$output" =  ${
      escapeShellArg (fileContents ./backend-tests/07.nix.output)
    } ]
    }

    @test "strip-nulls: print nulls with --with-nulls" {
    run ${terranix}/bin/terranix --with-nulls --quiet ${./backend-tests/07.nix}
    [ "$status" -eq 0 ]
    [ "$output" =  ${
      escapeShellArg (fileContents ./backend-tests/07-nulls.nix.output)
    } ]
    }
  ''

]
