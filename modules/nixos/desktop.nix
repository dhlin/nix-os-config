# KDE Plasma 6 for a QEMU/Proxmox guest viewed over SPICE.
#
# Uses Plasma's X11 session, since spice-vdagent's clipboard sharing and
# auto-resize only work on X11.
{
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm.enable = true;
      defaultSession = "plasmax11";
    };
    xserver.enable = true;
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  };
}
