# Typed options for every resource and data source of a provider, generated at
# eval time from the schema the provider reports (see ./schema.nix).
{ pkgs, lib }:
provider:

with lib;

let
  inherit (import ../core/types.nix lib) reference valueType;

  schema = import ./schema.nix { inherit pkgs; } provider;
  # only the type names, each type's block is imported once its options are needed
  index = importJSON "${schema}/index.json";
  importBlock = kind: type: importJSON "${schema}/${kind}/${type}.json";

  source = provider.provider-source-address;
  localName = last (splitString "/" source);

  # Terraform evaluates these itself, so they're valid for any attribute type,
  # e.g. `placement_group_id = config.resource.hcloud_placement_group.pg "id"`.
  expression = types.coercedTo reference toString (types.strMatching "[$][{].*}");
  orExpression = type: types.either type expression;

  # https://developer.hashicorp.com/terraform/plugin/sdkv2/schemas/schema-types
  typeFromSchema = type:
    if type == "string" then types.coercedTo reference toString types.str
    else if type == "number" then orExpression types.number
    else if type == "bool" then orExpression types.bool
    else if type == "dynamic" then valueType
    else
      let
        kind = head type;
        inner = elemAt type 1;
      in
      if kind == "list" || kind == "set" then orExpression (types.listOf (typeFromSchema inner))
      else if kind == "map" then orExpression (types.attrsOf (typeFromSchema inner))
      else if kind == "object" then
        orExpression (types.submodule {
          options = mapAttrs (_: t: optionalOption (typeFromSchema t) "") inner;
        })
      else if kind == "tuple" then orExpression (types.listOf valueType)
      else throw "terranix: unknown attribute type ${builtins.toJSON type} in ${source}";

  # protocol 6 nested attributes
  typeFromNestedType = nested:
    let
      object = types.submodule { options = attributeOptions nested.attributes; };
    in
    {
      single = object;
      list = types.listOf object;
      set = types.listOf object;
      map = types.attrsOf object;
    }.${nested.nesting_mode};

  optionalOption = type: description: mkOption {
    type = types.nullOr type;
    default = null;
    inherit description;
  };

  attributeOption = attribute:
    let
      type =
        if attribute ? nested_type
        then typeFromNestedType attribute.nested_type
        else typeFromSchema attribute.type;
      description = attribute.description or "";
    in
    if attribute.required or false
    then mkOption { inherit type description; }
    else optionalOption type description;

  # computed-only attributes can't be set, only referenced
  isSettable = attribute: attribute.required or false || attribute.optional or false;

  attributeOptions = attributes: mapAttrs (_: attributeOption) (filterAttrs (_: isSettable) attributes);

  blockOptions = block:
    attributeOptions (block.attributes or { })
    // mapAttrs (_: nestedBlockOption) (block.block_types or { });

  # coercedTo only uses this to recognise a lone block, the list type does the merging
  singleBlock = mkOptionType { name = "block"; check = isAttrs; };

  nestedBlockOption = nested:
    let
      object = types.submodule { options = blockOptions nested.block; };
      type = {
        single = object;
        group = object;
        # a single block can be given without wrapping it in a list
        list = types.coercedTo singleBlock singleton (types.listOf object);
        set = types.coercedTo singleBlock singleton (types.listOf object);
        map = types.attrsOf object;
      }.${nested.nesting_mode};
      description = nested.block.description or "";
    in
    if (nested.min_items or 0) > 0
    then mkOption { inherit type description; }
    else optionalOption type description;

  # https://developer.hashicorp.com/terraform/language/meta-arguments
  metaArgumentOptions = names: genAttrs names (_: optionalOption valueType "");
  resourceMetaArguments = [ "count" "for_each" "depends_on" "provider" "lifecycle" "provisioner" "connection" ];
  dataMetaArguments = [ "count" "for_each" "depends_on" "provider" "lifecycle" ];

  closest = attr: candidates:
    head (sortOn (strings.levenshtein attr) candidates);

  # one `<type>.<label>` block
  blockModule = { referencePrefix, type, block, metaArguments }: { name, ... }:
    let
      address = "${referencePrefix}${type}.${name}";
      referenceable = attrNames (block.attributes or { }) ++ attrNames (block.block_types or { });
    in
    {
      options = blockOptions block // metaArgumentOptions metaArguments // {
        # replaces the unchecked one from `withReference` in ../core/terraform-options.nix
        __functor = mkOption {
          type = types.raw;
          internal = true;
          readOnly = true;
          default = self: attr:
            if elem attr referenceable
            then "\${${address}.${attr}}"
            else throw "terranix: ${address} has no attribute `${attr}`, did you mean `${closest attr referenceable}`?";
        };
      };
    };

  typedBlocks = { kind, referencePrefix, metaArguments }:
    genAttrs index.${kind} (type:
      types.attrsOf (types.submodule (blockModule {
        inherit referencePrefix type metaArguments;
        block = importBlock kind type;
      })));
  # undeclared types are freeform in core, so a typo like `hcloud_sever` would pass silently
  unknownTypeAssertions = kind: blocks: known:
    let
      unknown = filter (type: hasPrefix "${localName}_" type && !(elem type known)) (attrNames blocks);
    in
    map
      (type: {
        assertion = false;
        message = "terranix: ${source} ${provider.version} has no ${kind} `${type}`, did you mean `${closest type known}`?";
      })
      unknown;
in
{ config, ... }: {
  config._typedBlocks.resource = typedBlocks {
    kind = "resource";
    referencePrefix = "";
    metaArguments = resourceMetaArguments;
  };

  config._typedBlocks.data = typedBlocks {
    kind = "data";
    referencePrefix = "data.";
    metaArguments = dataMetaArguments;
  };

  config.assertions =
    unknownTypeAssertions "resource" config.resource index.resource
    ++ unknownTypeAssertions "data source" config.data index.data;

  # pin terraform to the provider the options were generated from
  config.terraform.required_providers.${localName} = {
    source = removePrefix "registry.terraform.io/" source;
    inherit (provider) version;
  };
}
