# terranix vs HCL

The
[nix syntax](https://nixos.org/nix/manual/)
is similiar to the
[HCL syntax](https://github.com/hashicorp/hcl),
but much more powerful.

In **HCL** you would do something like this:

```hcl
resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld"
  }
}
```

Which is the equivalent for the following in **terranix**:

```nix
resource."aws_instance"."web" = {
  ami = "\${data.aws_ami.ubuntu.id}";
  instance_type = "t2.micro";
  tags = {
    Name = "HelloWorld";
  };
}
```

The same holds for `variable`, `output`, `data` and `provider`.

## multi line strings

In terraform you can create multi line strings using the `heredoc` style

```hcl
variable "multiline" {
  description = <<EOT
Description for the multi line variable.
The indention here is not wrong.
The terminating word must be on a new line without any indention.
EOT
}
```

This won't work in terranix.
In terranix you have to use the nix way of multi line strings.

```nix
variable.multiline.description = ''
  Description for the multi line variable.
  The indention here is not wrong.
  All spaces in front of the text block will be removed by terranix.
'';
```

## escaping expressions

The form `${expression}` is used by terranix and terraform.
So, if you want to use a terraform expression in terranix,
you have to escape it.
There are the two context, multi and single line strings.

### escaping expressions in single line strings

In single line strings, you escape the via `\${expression}`.
For example :

```nix
variable.hcloud_token = {};
provider.hcloud.token = "\${var.hcloud_token}";
```

### escaping expressions in multi line strings

In multi line strings, you escape via `''${expression}`.
For example :

```nix
resource.local_file.sshConfig = {
  filename = "./ssh-config";
  content = ''
    Host ''${ hcloud_server.terranix_test.ipv4_address }
    IdentityFile ./sshkey
  '';
};
```
