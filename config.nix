{config , ... }:
let

  get = element: object:
      "\${ ${object."_ref"}.${element} }";

  getVariable = name:
      "\${ var.${name} }";

in {

  cloudflare = {
    enable = true;

    provider = {
      email = "hallo";
    };

    #resource.zone_settings_override = {
    #  settings = { };
    #};
  };

  hcloud = {
    enable = false;

    resource = {

    server.nginx = {
      name = "mein.nginx";
      image  = "debian-9";
      server_type = "cx11";
      backups = false;
      extraConfig = {
        provider = "Deine Mudda";
        deine_mutter =  {
          what = "ever";
        };
      };
    };

    volume.test = {
      name = "test_instance";
      size = 10;
      extraConfig = {
        provider = "Deine Mudda";
        deine_mutter =  {
          what = "ever";
        };
      };
    };

  };
};


}
