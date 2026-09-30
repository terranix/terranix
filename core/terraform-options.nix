# core options
#

{ lib, ... }:

with lib;

let
  mkMagicMergeOption =
    { description ? ""
    , example ? { }
    , default ? { }
    , apply ? id
    , ...
    }:
    mkOption {
      inherit
        example
        description
        default
        apply
        ;
      type =
        with lib.types;
        let
          # a block from `withReference` used as a value, e.g. `token = config.variable.token`
          reference = mkOptionType {
            name = "reference";
            check = v: isAttrs v && v ? __toString;
            merge = mergeEqualOption;
          };
          valueType =
            nullOr
              (oneOf [
                bool
                int
                float
                (coercedTo reference toString str)
                (attrsOf valueType)
                (listOf valueType)
              ])
            // {
              description = "bool, int, float or str";
              emptyValue.value = { };
            };
        in
        valueType;
    };

  mapAttrsOrSkip = f: attrs: if isAttrs attrs then mapAttrs f attrs else attrs;

  # `block "attr"` references an attribute of the block, `block` or `"${block}"` the
  # block itself. The helpers are stripped from the block by `sanitize` in ./default.nix.
  withReference = address: block:
    if isAttrs block then
      block // {
        __functor = self: attr: "\${${address}.${attr}}";
        __toString = self: "\${${address}}";
      }
    else
      block;

  # for blocks addressed as `<type>.<label>`, like resource and data
  mkReferenceableOption =
    { referencePrefix ? ""
    , ...
    }@args:
    mkMagicMergeOption (
      args
      // {
        apply = mapAttrsOrSkip (
          type: mapAttrsOrSkip (label: withReference "${referencePrefix}${type}.${label}")
        );
      }
    );

  # for blocks addressed as `<name>`, like variable and module
  mkNamedReferenceableOption =
    { referencePrefix
    , ...
    }@args:
    mkMagicMergeOption (
      args
      // {
        apply = mapAttrsOrSkip (name: withReference "${referencePrefix}${name}");
      }
    );
in
{

  options = {

    # Out-of-band metadata for downstream consumers similar to nixpkgs passthru.
    # This option is never rendered to Terraform JSON.
    _meta = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      internal = true;
      description = "Arbitrary metadata attached to a terranix evaluation result.";
    };

    # Checked in core/default.nix once the configuration is assembled.
    # Neither option is rendered to Terraform JSON.
    assertions = mkOption {
      type = types.listOf types.unspecified;
      default = [ ];
      internal = true;
      example = [{
        assertion = false;
        message = "you can't enable this for that reason";
      }];
      description = ''
        Conditions that must hold for the evaluation of the terranix
        configuration to succeed, together with the message shown to the
        user when they do not.
      '';
    };

    warnings = mkOption {
      type = types.listOf types.str;
      default = [ ];
      internal = true;
      example = [ "The etcd backend is deprecated and will go away soon!" ];
      description = ''
        Messages to show to users during the evaluation of the terranix
        configuration, without failing it.
      '';
    };

    ephemeral = mkReferenceableOption {
      referencePrefix = "ephemeral.";
      description = ''
        Ephemeral objects, are a temporary resource, they are not stored.
        See for more details : https://developer.hashicorp.com/terraform/language/resources/ephemeral
      '';
    };
    data = mkReferenceableOption {
      referencePrefix = "data.";
      description = ''
        Data objects, are queries to use resources which
        are already exist, as if they are created by a the resource
        option.
        See for more details : https://www.terraform.io/docs/configuration/data-sources.html
      '';
    };
    locals = mkMagicMergeOption {
      example = {
        locals = {
          service_name = "forum";
          owner = "Community Team";
        };
      };
      description = ''
        Define terraform variables with file scope.
        Like modules this is terraform intern and terranix has better ways.
        See for more details : https://www.terraform.io/docs/configuration/locals.html
      '';
    };
    import = mkMagicMergeOption {
      example = {
        import = [
          {
            to = "aws_instance.example";
            id = "i-abcd1234";
          }
        ];
      };
      description = ''
        Define terraform import.
        See for more details : https://developer.hashicorp.com/terraform/language/import
      '';
    };
    module = mkNamedReferenceableOption {
      referencePrefix = "module.";
      example = {
        module.consul = {
          source = "github.com/hashicorp/example";
        };
      };
      description = ''
        A terraform module, to define multiple resources,
        for sharing or duplication.
        The terraform module system, and has nothing to
        do with the module system of terranix or nixos.
        See for more details : https://www.terraform.io/docs/configuration/modules.html
      '';
    };
    moved = mkMagicMergeOption {
      example = {
        moved = [
          {
            from = "aws_instance.example";
            to = "aws_instance.other_example";
          }
        ];
      };
      description = ''
        Move a resource from one address to another.
        See for more details : https://developer.hashicorp.com/terraform/language/block/moved
      '';
    };
    output = mkMagicMergeOption {
      example = {
        output.instance_ip_addr.value = "aws_instance.server.private_ip";
      };
      description = ''
        Useful in combination with terraform_remote_state.
        See for more details : https://www.terraform.io/docs/configuration/outputs.html
      '';
    };
    provider = mkMagicMergeOption {
      example = {
        provider.google = {
          project = "acme-app";
          region = "us-central1";
        };
      };
      description = ''
        Define you API connection.
        Don't use secrets in here, they will be visible in the nix-store and the resulting
        config.tf.json. Instead use terraform variables.
        See for more details : https://www.terraform.io/docs/configuration/providers.html
        or https://www.terraform.io/docs/providers/index.html
      '';
    };
    removed = mkMagicMergeOption {
      example = {
        removed = [
          {
            from = "aws_instance.example";
            lifecycle.destroy = false;
          }
        ];
      };
      description = ''
        Define a removed resource.
        See for more details : https://developer.hashicorp.com/terraform/language/state/remove
      '';
    };
    resource = mkReferenceableOption {
      example = {
        resource.aws_instance.web = {
          ami = "ami-a1b2c3d4";
          instance_type = "t2.micro";
        };
      };
      description = ''
        The backbone of terraform and terranix to change and create state.
        See for more details : https://www.terraform.io/docs/configuration/resources.html
      '';
    };
    terraform = mkMagicMergeOption {
      example = {
        terraform = {
          backend.s3 = {
            bucket = "mybucket";
            key = "path/to/my/key";
            region = "us-east-1";
          };
        };
      };
      description = ''
        Terraform configuration.
        But for backends have a look at the terranix options
        backend.etcd, backend.local and backend.s3.
        See for more details : https://www.terraform.io/docs/configuration/terraform.html
      '';
    };
    variable = mkNamedReferenceableOption {
      referencePrefix = "var.";
      example = {
        variable.image_id = {
          type = "string";
          description = "The id of the machine image (AMI) to use for the server.";
        };
      };
      description = ''
        Input Variables, which can be set by `--var=name` or by environment variables prefixt with `TF_VAR_`.
        Usually used in terraform modules or to ask for API tokens.
        See for more details : https://www.terraform.io/docs/configuration/variables.html
      '';
    };
  };
}
