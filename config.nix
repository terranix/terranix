{config , ... }:
let

  get = element: object:
      "\${ ${object."_ref"}.${element} }";

  getVariable = name:
      "\${ var.${name} }";

in {

  cloudflare = {
    enable = false;
    # provider.email = "test@google.com";
    # provider.token = "hallo";
  };


  hcloud = {
    enable = true;

    # provider.token = "hallo";

    resource = {

    server.nginx = {
      name = "main_nginx";
      image  = "debian-9";
      server_type = "c11";
      # backups = false;
    };

    volume.test = {
      name = "${config.hcloud.resource.server.nginx.name}-volume";
      # size = 1;
      # server = get "id" config.hetzner.server.nginx;
      # location = "de";
    };
  };
};

  #resource.this.is.a.simple.test = "yeah";

}
