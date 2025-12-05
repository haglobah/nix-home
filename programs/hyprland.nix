{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    plugins = with pkgs.hyprlandPlugins; [
      xtra-dispatchers
    ];
  };
}
