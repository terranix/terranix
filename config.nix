{config , ... }:
let

  get = element: object:
      "\${ ${object."_ref"}.${element} }";

  getVariable = name:
      "\${ var.${name} }";

in {


  hcloud = {
    enable = true;

    resource = {

    server.nginx = {
      name = "mein.nginx";
      image  = "debian-9";
      server_type = "cx11";
      backups = false;
    };

  };
};


}
