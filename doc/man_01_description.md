# DESCRIPTION

Terranix is a NixOS way to generate terraform json.
You can create modules like you would in NixOS.

The
[nix syntax](https://nixos.org/nix/manual/)
is similiar to the
[HCL syntax](https://github.com/hashicorp/hcl)
but, much more powerfull.

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
