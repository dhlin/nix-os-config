{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    sysstat
    bcc
    bpftrace
    perf
    strace

    # disk and io
    fio
    iotop
    lsof
    ncdu

    # network
    bandwhich
    iftop
    iperf3
    nethogs
    tcpdump
  ];

  services.sysstat.enable = true;
}
