{...}:
{

  users.admins.palo.publicKey = "ssh-rsa asdfasdf ";

  #backend.local.path = "./my-terraform-state.tfstate";

  backend.s3 = {
    bucket  = "some-where-over-the-rainbow";
    key = "my-terraform-state.tfstate";
    region = "eu-central-1";
  };

  #backend.etcd = {
  #  path = "/";
  #  endpoints = "https://one";
  #};

  remote_state.s3.test = {
    bucket  = "some-where-over-the-rainbow";
    key = "my-terraform-state.tfstate";
    region = "eu-central-1";
  };

  # todo : fix this
  remote_state.local.test2 = {
    path = "some-where-over-the-rainbow";
  };

  resource.hcloud_server.nginx = {
    name = "terranix.nginx";
    image  = "debian-10";
    server_type = "cx11";
    backups = false;
  };
  resource.hcloud_server.test = {
    name = "terranix.test";
    image  = "debian-9";
    server_type = "cx11";
    backups = true;
  };
}
