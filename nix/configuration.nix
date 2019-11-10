{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

   i18n = {
     consoleKeyMap = "us";
     defaultLocale = "en_US.UTF-8";
   };

  time.timeZone = "Europe/Amsterdam";

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    clang
    cmake
    git
    gnumake
    firefox
  ];

  fonts.fonts = with pkgs; [ inconsolata ];

  sound.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.libinput.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.desktopManager.default = "gnome3";

  services.printing.enable = true;

  users.users.jfo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    uid = 1000;
    packages = with pkgs; [
      ag
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
      python
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
}
