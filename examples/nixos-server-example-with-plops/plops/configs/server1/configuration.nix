{ config, pkgs, lib , ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./gogs.nix
  ];

  services.sshd.enable = true;

  environment.systemPackages = [ pkgs.git ];

  networking.hostName = "server1";


  # the public ssh key used at deployment
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCb5ztD3BvAHSOk+fac6Q4c8uvZUJWLmchMWPz87pw6lRyyCyDX/lhs9V6IapvMvN3Z6jHCl7H5Zyn6gSAk78fVPY0/aeexGqxzNtxlcABOcd6BrreoAnBb4EObLCNkVYCBQHlVJdRuLCpXepS/nltc6q29jR/it07y1BehaOKkbP/Xo39jrqWhQkfvBvjVdKW6jgVk5Gwry7meHrbwS04fyTUcMzXx9KmenVnNaUEs/FITf3f/k5+0miHMXY3u7F4Ct3fUjkfg8sEEVLLRmHSacozu7BsLI/EUjWQODAYHPc/m0GLSnE2MCu+q/POfiHOfTaOx/rD8x7XQN6zrNEDPBgqv8+Tla9WeuZtlDKK9BW/k7W790SbsIj8Ii4kDotk8DYncg2+FWXxb6+qyX84p96Swkm/eyg/4WiZzLY2iQ2Y6ZJ2XvS5N9wCSB+5GsJC8OVYJLohBqd2O5oOh6ovK7UwDPxF4o37IMwfn1D/4f5NZ/Uwcbecn4l/Jw5wsUn65yLaRqYJ9VlrnSbtPOkJWqOB0Hs9SmRxpOVAf6wnuLgN1vPv7Fq68V1V0AmO0DTd5MalXbFwr4fNm+FxmDkAKhhiDmy+BlRrOjQFzV/IrZqrAcYcTPtfx13UQGm4hC2+zCVzamQgWKzeE1DjSp17fLi9DHj3q4uPsTRQzM8IgFw== palo@pepe"
  ];

}
