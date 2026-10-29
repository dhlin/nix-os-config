# Immich photo server, layered on the shared defaults in ./default.nix.
# Autowired to `nixosModules.immich`.
#
# Nothing here repeats the default profile: it already disables the firewall
# (so `openFirewall` is unneeded) and runs tailscale, which is how the server
# is reached off-box.
{
  config,
  flake,
  pkgs,
  ...
}: let
  # Already-formatted ext4 filesystem to mount at
  # `services.immich.mediaLocation`. Prefer a stable path under
  # /dev/disk/by-label or by-uuid over /dev/sdX. Format it yourself first,
  # e.g. `mkfs.ext4 -L immich-media /dev/sdb`.
  mediaDevice = "/dev/sdb";

  # Major PostgreSQL version for the local database. Changing the major
  # version of an existing database needs a manual dump and restore.
  postgresPackage = pkgs.postgresql_18;
in {
  services.postgresql.package = postgresPackage;

  # A systemd mount rather than fileSystems/fstab, so it belongs to the Immich
  # service: wantedBy pulls it in when the server starts, and RequiresMountsFor
  # makes the server wait for it and refuse to start if it fails. Otherwise a
  # missing disk leaves an empty directory on the root disk and Immich quietly
  # writes media there.
  systemd.mounts = [
    {
      type = "ext4";
      what = mediaDevice;
      where = config.services.immich.mediaLocation;
      wantedBy = ["immich-server.service"];
    }
  ];

  # wantedBy alone only starts the mount alongside the server: no ordering, and
  # a failed mount does not stop the server. This adds Requires= and After= on
  # the mount, so the server waits for the disk, won't start without it, and
  # stops if it is unmounted.
  systemd.services.immich-server.unitConfig.RequiresMountsFor = [config.services.immich.mediaLocation];

  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 2283;

    # Uploads, thumbnails and transcodes. Point this at a bigger disk or mount
    # when the root partition is small.
    mediaLocation = "/var/lib/immich";

    # Machine learning (face and object recognition, smart search) runs locally.
    machine-learning.enable = true;

    # Postgres and redis stay on and local: Immich cannot run without them, and
    # turning either off means pointing it at an external instance by hand.
    database = {
      enable = true;
      createDB = true;
      name = "immich";
      user = "immich";
    };
    redis.enable = true;
    # The stable channel lags upstream releases, and Immich moves fast, so take
    # the package from unstable while the module itself stays on 25.11.
    package = flake.inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.immich;
  };
}
