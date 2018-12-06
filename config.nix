{config , ... }:
{

  cloudflare = {
    enable = true;
    provider.email = "test@google.com";
    # provider.token = "hallo";
  };

  hetzner = {
    enable = true;
    # provider.token = "hallo";

    server = {
      nginx = {
        name = "nginx-node";
        image  = "debian-9";
      };
      test = {
        name = "test-node";
        image  = "debian-9";
      };
    };

    volume.test = {
      name = "this-ist-a-test";
      size = 10;
      # todo : this is how I want to call it 
      # server = config.hetzner.server.nginx;
      server = "\${hcloud_server.${config.hetzner.server.nginx.name}.id}";
      # server = get "id" config.hetzner.server.nginx.name;
      # server = "\${hcloud_server.node1.id}";
      # todo : this option needs to be variable, without defining everything a head
      # location = "de";
    };
  };

  resource.this.is.a.simple.test = "yeah";

}