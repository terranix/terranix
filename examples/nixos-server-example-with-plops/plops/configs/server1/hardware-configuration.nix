{ ... }:
{
  imports = [ <nixpkgs/nixos/modules/profiles/qemu-guest.nix> ];
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sd_mod" "sr_mod" ];
  boot.loader.grub.device = "/dev/sda";
  fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };
}
