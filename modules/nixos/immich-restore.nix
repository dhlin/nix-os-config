{
  config,
  lib,
  pkgs,
  ...
}: let
  backupDevice = "/dev/disk/by-label/PhotoBackup";
  mountPoint = "/var/lib/immich-restore";
  mediaLocation = "${mountPoint}/immich";
  backupDir = "${mediaLocation}/backups";

  # Kept in the postgres data dir so wiping the database also re-arms the restore.
  restoredStamp = "${config.services.postgresql.dataDir}/.immich-restored";
in {
  imports = [./immich.nix];

  boot.supportedFilesystems = ["exfat"];

  # Replace the ext4 media disk mount from immich.nix with the exFAT backup disk.
  # exFAT has no unix ownership, so hand everything to the immich user and keep
  # it readable for postgres to load the dump.
  systemd.mounts = lib.mkForce [
    {
      type = "exfat";
      what = backupDevice;
      where = mountPoint;
      options = "uid=immich,gid=immich,umask=0022";
      wantedBy = ["immich-server.service" "immich-restore.service"];
    }
  ];

  # Override the port and media location set in immich.nix. Because of these
  # overrides, a host imports either this module or immich.nix, never both.
  services.immich = {
    port = lib.mkForce 2284;
    mediaLocation = lib.mkForce mediaLocation;
  };

  # Load the latest database backup once, after postgres has created the immich
  # database and before the server starts.
  systemd.services.immich-restore = {
    description = "Restore Immich database from the latest backup";
    requires = ["postgresql.service"];
    after = ["postgresql.service" "postgresql-setup.service"];
    before = ["immich-server.service"];
    requiredBy = ["immich-server.service"];
    unitConfig = {
      RequiresMountsFor = [mediaLocation];
      ConditionPathExists = "!${restoredStamp}";
    };
    path = [pkgs.gzip pkgs.gnused config.services.postgresql.package];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "postgres";
    };
    script = ''
      set -o pipefail
      shopt -s nullglob

      # Backup names embed a timestamp, so the last one in glob order is the latest.
      backups=(${backupDir}/immich-db-backup-*.sql.gz)
      if [ ''${#backups[@]} -eq 0 ]; then
        echo "no backups found in ${backupDir}" >&2
        exit 1
      fi
      latest="''${backups[-1]}"
      echo "restoring $latest"

      gunzip --stdout "$latest" \
        | sed "s/SELECT pg_catalog.set_config('search_path', ''', false);/SELECT pg_catalog.set_config('search_path', 'public, pg_catalog', true);/g" \
        | psql --dbname=${config.services.immich.database.name} --single-transaction --set ON_ERROR_STOP=on

      echo "$latest" > ${restoredStamp}
    '';
  };
}
