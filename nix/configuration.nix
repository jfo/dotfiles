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
    ag
    clang
    cmake
    firefox
    fzf
    gettext
    git
    gnumake
    hugo
    neovim
    nodejs-9_x
    pass
    php
    python
    ruby
    steam
    tmux
    vim
    weechat
    wget
    xclip
    zig
  ];

  fonts.fonts = with pkgs; [ inconsolata ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.driSupport32Bit = true;
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.libinput.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.desktopManager.default = "gnome3";

  users.extraUsers.jfo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    uid = 1000;
  };

  system.stateVersion = "18.03";

  networking.hosts."127.0.0.1" = [
    "twitter.com"
    "www.twitter.com"
    "facebook.com"
    "www.facebook.com"
    "reddit.com"
    "www.reddit.com"
  ];
}
