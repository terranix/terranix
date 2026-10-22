# The provider's schema, dumped by opentofu inside the sandbox and split into
# `index.json` (the type names) plus one `<kind>/<type>.json` per type, so eval
# only parses the types a config uses. A full aws schema is ~100 MB and takes
# seconds to parse on every eval. Descriptions are dropped for the same reason,
# they're ~90% of it.
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
pkgs.runCommand "${localName}-${provider.version}-schema"
  {
    nativeBuildInputs = [ tofu pkgs.jq ];
    passAsFile = [ "stub" ];
    inherit stub;
  }
  ''
    export HOME=$TMPDIR
    mkdir work && cd work
    cp $stubPath main.tf.json
    # nix streams IFD build logs into the caller's stderr, so a cold schema
    # build would otherwise splice init's chatter into terranix's output
    tofu init -backend=false -input=false > init.log 2>&1 || { cat init.log >&2; exit 1; }
    # opentofu reports it under registry.opentofu.org, whatever the source says
    tofu providers schema -json \
      | jq -e '.provider_schemas | if length == 1 then to_entries[0].value else error("expected one provider, got \(keys)") end' \
      > schema.json

    mkdir -p $out/resource $out/data
    jq -c '{ resource: (.resource_schemas // {} | keys), data: (.data_source_schemas // {} | keys) }' schema.json > $out/index.json
    # One `<kind> <type> <block>` line per type, in a single pass over the schema.
    # Strips by structure rather than `walk`, which would also drop attributes
    # that happen to be named `description`. base64 because @tsv escapes the
    # backslashes inside the JSON.
    jq -r '
      def attribute: del(.description, .description_kind, .deprecated)
        | if .nested_type then .nested_type.attributes |= map_values(attribute) else . end;
      def block: del(.description, .description_kind, .deprecated)
        | if .attributes then .attributes |= map_values(attribute) else . end
        | if .block_types then .block_types |= map_values(.block |= block) else . end;
      (.resource_schemas // {} | to_entries[] | ["resource", .key, (.value.block | block | tojson | @base64)]),
      (.data_source_schemas // {} | to_entries[] | ["data", .key, (.value.block | block | tojson | @base64)])
      | @tsv' schema.json \
      | while IFS=$'\t' read -r kind type block; do
          printf '%s' "$block" | base64 -d > "$out/$kind/$type.json"
        done
  ''
