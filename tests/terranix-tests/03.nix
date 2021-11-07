{ ... }:
{

  remote_state.s3.test = {
    bucket = "some-where-over-the-rainbow";
    key = "my-terraform-state.tfstate";
    region = "eu-central-1";
  };

  remote_state.local.test = {
    path = "some-where-over-the-rainbow";
  };

}
