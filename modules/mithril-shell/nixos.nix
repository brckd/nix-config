{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.services.mithril-shell;
in {
  options.services.mithril-shell = {
    enable = mkEnableOption "Mithril Shell";
  };

  config = mkIf cfg.enable {
    fonts.packages = [pkgs.adwaita-fonts];
    hardware.bluetooth.enable = true;
    networking.networkmanager.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

    programs.dconf.enable = true;
    programs.geary.enable = true; # Mail client
    programs.gnome-disks.enable = true; # Disks viewer
    programs.hyprland.enable = true; # Wayland compositor
    programs.seahorse.enable = true; # Secrets manager
    services.udisks2.enable = true; # Mount disks
    services.upower.enable = true; # Battery status

    environment.systemPackages = [
      pkgs.decibels # Audio player
      pkgs.eloquent # Proofreading software
      pkgs.file-roller # Archive manager
      pkgs.ghostty # Terminal emulator
      pkgs.gimp3 # Image editor
      pkgs.gnome-text-editor # Text editor
      pkgs.gnome-calculator # Calculator application
      pkgs.gnome-calendar # Calendar application
      pkgs.gnome-characters # Characters viewer
      pkgs.gnome-clocks # Clock application
      pkgs.gnome-font-viewer # Font library
      pkgs.gnome-logs # Systemd journal viewer
      pkgs.gnome-maps # Map application
      pkgs.gnome-weather # Weather application
      pkgs.ghex # Hex editor
      pkgs.grim # Screenshot application
      pkgs.handbrake # Video converter
      pkgs.inkscape # Vector graphics editor
      pkgs.inspector # System information viewer
      pkgs.libreoffice # Office application
      pkgs.loupe # Image viewer
      pkgs.mission-center # System monitor
      pkgs.nautilus # File manager
      pkgs.papers # Document viewer
      pkgs.snapshot # Camera application
      pkgs.totem # Movie player
      pkgs.tuba # Mastodon client
      pkgs.wl-clipboard # Clipboard manager
      (pkgs.writeShellScriptBin "xdg-terminal-exec" "ghostty -e $@")
    ];
  };
}
