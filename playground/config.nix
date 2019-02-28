{...}:
{

  users.admins.palo.ssh_key = "ssh-rsa asdfasdf ";

  # backend.local.path = "./my-terraform-state.tfstate";

  #backend.s3 = {
  #  bucket  = "some-where-over-the-rainbow";
  #  key = "my-terraform-state.tfstate";
  #  region = "eu-central-1";
  #};

  backend.etcd = {
    path = "/";
    endpoints = "https://one";
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
