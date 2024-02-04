{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

   console.keyMap = "us";

   i18n = {
     defaultLocale = "en_US.UTF-8";
   };

  time.timeZone = "Europe/Amsterdam";

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    clang
    cmake
    git
    gnumake
  ];

  programs.firefox.enable = true;

  fonts.packages = with pkgs; [ inconsolata ];

  programs.fish.enable = true;
  sound.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.xserver.libinput.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.defaultSession = "gnome";

  services.printing.enable = true;

  users.users.jfo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    uid = 1000;
    shell = pkgs.fish;
    packages = with pkgs; [
      silver-searcher
      arduino
      awscli
      binaryen
      dropbox-cli
      fzf
      geteltorito
      gettext
      hugo
      liblo
      libusb1
      mutt
      neovim
      nodejs_latest
      pass
      php
      ruby
      spotify
      steam
      steam-run
      teensy-loader-cli
      tmux
      usbutils
      vim
      wabt
      weechat
      wget
      xclip
      zig
    ];
  };

  system.stateVersion = "18.03";

  networking.hosts."127.0.0.1" = [ "dev.jfo.click" ];

  services.openvpn.servers = {
    ExpressVPN.config = "~/my_expressvpn_denmark_upd.ovpn";
  };
}
