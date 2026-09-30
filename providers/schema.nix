# The provider's schema as JSON, dumped by opentofu inside the sandbox.
# Uses the nixpkgs provider package, so the schema always matches the provider
# that `opentofu.withPlugins` will run.
{ pkgs }:
provider:
let
  source = provider.provider-source-address;
  # `registry.terraform.io/hetznercloud/hcloud` → `hetznercloud/hcloud`
  shortSource = pkgs.lib.removePrefix "registry.terraform.io/" source;
  localName = pkgs.lib.last (pkgs.lib.splitString "/" source);
  tofu = pkgs.opentofu.withPlugins (_: [ provider ]);
  stub = builtins.toJSON {
    terraform.required_providers.${localName} = {
      source = shortSource;
      version = provider.version;
    };
  };
in
pkgs.runCommand "${localName}-${provider.version}-schema.json"
  {
    nativeBuildInputs = [ tofu pkgs.jq ];
    passAsFile = [ "stub" ];
    inherit stub;
  }
  ''
    export HOME=$TMPDIR
    mkdir work && cd work
    cp $stubPath main.tf.json
    tofu init -backend=false -input=false >&2
    # opentofu reports it under registry.opentofu.org, whatever the source says
    tofu providers schema -json \
      | jq -e '.provider_schemas | if length == 1 then to_entries[0].value else error("expected one provider, got \(keys)") end' \
      > $out
  ''
