{
  config,
  flake,
  pkgs,
  ...
}: let
  # Already-formatted filesystem to mount. Format it yourself first,
  # e.g. `mkfs.ext4 -L immich-media /dev/sdX`. Referenced by label because
  # /dev/sdX names are not stable across reboots.
  mediaDevice = "/dev/disk/by-label/immich-media";

  postgresPackage = pkgs.postgresql_18;

  immichPackage = flake.inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.immich;
in {
  services.postgresql.package = postgresPackage;

  # Mount the media disk before starting the server.
  systemd.mounts = [
    {
      type = "ext4";
      what = mediaDevice;
      where = config.services.immich.mediaLocation;
      wantedBy = ["immich-server.service"];
    }
  ];

  # Ensure the Immich server waits for the media disk to be mounted and fails if it is not available.
  systemd.services.immich-server.unitConfig.RequiresMountsFor = [config.services.immich.mediaLocation];

  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 2283;

    mediaLocation = "/var/lib/immich";

    machine-learning.enable = true;

    database = {
      enable = true;
      createDB = true;
      name = "immich";
      user = "immich";
    };
    redis.enable = true;
    package = immichPackage;
  };
}
