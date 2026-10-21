# Immich photo server, layered on the shared defaults in ./default.nix.
# Autowired to `nixosModules.immich`.
#
# Nothing here repeats the default profile: it already disables the firewall
# (so `openFirewall` is unneeded) and runs tailscale, which is how the server
# is reached off-box.
{
  config,
  flake,
  lib,
  pkgs,
  ...
}: let
  cfg = config.immich;
in {
  options.immich.machineLearningUrl = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    example = "http://gpu-box:3003";
    description = ''
      Machine-learning server to use instead of a local one. Null runs
      the local one. Setting it makes `services.immich.settings`
      declarative, so the admin UI can no longer change server settings.
    '';
  };

  options.immich.mediaDevice = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    example = "/dev/disk/by-label/immich-media";
    description = ''
      Already-formatted ext4 filesystem to mount at
      `services.immich.mediaLocation`. Prefer a stable path under
      /dev/disk/by-label or by-uuid over /dev/sdX. Format it yourself first,
      e.g. `mkfs.ext4 -L immich-media /dev/sdb`. Null keeps media on the root
      disk.
    '';
  };

  options.immich.postgresVersion = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    example = "16";
    description = ''
      Major PostgreSQL version for the local database, taken from
      `pkgs.postgresql_<version>`. Null keeps the NixOS default. Changing the
      major version of an existing database needs a manual dump and restore.
    '';
  };

  config.services.postgresql.package = lib.mkIf (cfg.postgresVersion != null) pkgs."postgresql_${cfg.postgresVersion}";

  # A systemd mount rather than fileSystems/fstab, so it belongs to the Immich
  # service: wantedBy pulls it in when the server starts, and RequiresMountsFor
  # makes the server wait for it and refuse to start if it fails. Otherwise a
  # missing disk leaves an empty directory on the root disk and Immich quietly
  # writes media there.
  config.systemd.mounts = lib.mkIf (cfg.mediaDevice != null) [
    {
      type = "ext4";
      what = cfg.mediaDevice;
      where = config.services.immich.mediaLocation;
      wantedBy = ["immich-server.service"];
    }
  ];

  config.systemd.services.immich-server.unitConfig.RequiresMountsFor =
    lib.mkIf (cfg.mediaDevice != null) [config.services.immich.mediaLocation];

  config.services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 2283;

    # Uploads, thumbnails and transcodes. Point this at a bigger disk or mount
    # when the root partition is small.
    mediaLocation = "/var/lib/immich";

    # Run it locally unless `immich.machineLearningUrl` offloads it elsewhere.
    machine-learning.enable = true;
    settings = lib.mkIf (cfg.machineLearningUrl != null) {
      machineLearning = {
        enabled = true;
        urls = [cfg.machineLearningUrl];
      };
    };

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
