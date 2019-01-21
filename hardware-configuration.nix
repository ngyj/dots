# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4e2d768f-1cee-445a-a646-05376c472e8a";
      fsType = "xfs";
    };

  boot.initrd.luks.devices."nixos".device = "/dev/disk/by-uuid/55a8d607-cdc5-425c-bb88-397b9a658168";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8975-03AD";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/9cc605a5-92aa-437f-b2b7-517e4553a9b0";
      fsType = "xfs";
    };

  fileSystems."/home/aigis" =
    { device = "dev/disk/by-label/aigis";
      fsType = "xfs";
    };

# boot.initrd.luks.devices."home".device = "/dev/disk/by-uuid/cfead87d-8872-43a5-ac1d-a6b243023815";

  swapDevices =
    [ { device = "/dev/disk/by-uuid/f5cebe18-ebd8-492f-a57b-d419a31db206"; }
    ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
