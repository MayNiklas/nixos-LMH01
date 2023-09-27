{ lib, pkgs, config, ... }:
with lib;
let cfg = config.lmh01.xserver;
in
{

  options.lmh01.xserver.enable = mkEnableOption "activate xserver";


  config = mkIf cfg.enable {

    # Enable the X11 windowing system.
    services.xserver = {
      layout = "de";
      enable = true;
      autorun = true;
      libinput = {
        enable = true;
        touchpad.accelProfile = "flat";
      };

      desktopManager = {
        xterm.enable = false;
        session = [{
          name = "home-manager";
          start = ''
            export `dbus-launch`
            ${pkgs.runtimeShell} $HOME/.hm-xsession &
             waitPID=$!
          '';
        }];
      };

    };

    # Enable pulseaudio compatible api for audio volume control in i3
    services.pipewire.pulse.enable = true;

    environment.systemPackages = with pkgs; [
      pulseaudio
    ];

  };
}
