{ ... }:
{

  backend.s3 = {
    bucket = "some-where-over-the-rainbow";
    key = "my-terraform-state.tfstate";
    region = "eu-central-1";
  };

  backend.etcd = {
    path = "/";
    endpoints = "https://one";
  };

}
