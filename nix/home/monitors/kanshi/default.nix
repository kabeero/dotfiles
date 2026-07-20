# ╭────────────╮
# │   kanshi   │
# ╰────────────╯

{ config, pkgs, ... }:

{
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "Sharp Corporation LQ*";
            mode = "3840x2400@59.99Hz";
            position = "0,0";
            scale = 1.5;
            transform = "normal";
            status = "enable";
          }
        ];
      }
      {
        profile.name = "tronics";
        profile.outputs = [
          {
            criteria = "Sharp Corporation LQ*";
            mode = "3840x2400@59.99Hz";
            position = "640,2160";
            scale = 1.5;
            transform = "normal";
          }
          {
            criteria = "Dell Inc. DELL UP3221Q *";
            mode = "3840x2160@60.00Hz";
            position = "0,0";
            scale = 1.0;
            transform = "normal";
          }
        ];
      }
      {
        profile.name = "work-1-left";
        profile.outputs = [
          {
            criteria = "Sharp Corporation LQ*";
            mode = "3840x2400@59.99Hz";
            position = "0,0";
            scale = 1.5;
            status = "disable";
          }
          {
            criteria = "Dell Inc. DELL UP3221Q D*";
            mode = "3840x2160@59.94Hz";
            position = "0,0";
            scale = 1.0;
            transform = "90";
          }
        ];
      }
      {
        profile.name = "work-1-mid";
        profile.outputs = [
          {
            criteria = "Sharp Corporation LQ*";
            mode = "3840x2400@59.99Hz";
            position = "0,0";
            scale = 1.5;
            status = "disable";
          }
          {
            criteria = "Dell Inc. DELL U3223QE C*";
            mode = "3840x2160@60.00Hz";
            position = "2160,0";
            scale = 1.0;
            transform = "90";
          }
        ];
      }
      {
        profile.name = "work-1";
        profile.outputs = [
          {
            criteria = "Dell Inc. DELL U3223QE C*";
            mode = "3840x2160@60.00Hz";
            position = "2160,0";
            scale = 1.0;
            transform = "90";
          }
        ];
      }
      {
        profile.name = "work-2";
        profile.outputs = [
          {
            criteria = "Sharp Corporation LQ*";
            mode = "3840x2400@59.99Hz";
            position = "0,0";
            scale = 1.5;
            status = "disable";
          }
          {
            criteria = "Dell Inc. DELL UP3221Q D*";
            mode = "3840x2160@59.94Hz";
            position = "0,0";
            scale = 1.0;
            transform = "90";
          }
          {
            criteria = "Dell Inc. DELL U3223QE C*";
            mode = "3840x2160@60.00Hz";
            position = "2160,0";
            scale = 1.0;
            transform = "90";
          }
        ];
      }
      {
        profile.name = "work-2-2025a";
        profile.outputs = [
          {
            criteria = "Dell Inc. DELL UP3221Q D*";
            mode = "3840x2160";
            position = "0,0";
            scale = 1.0;
            transform = "90";
          }
          {
            criteria = "Dell Inc. DELL U3223QE C*";
            mode = "3840x2160";
            position = "2160,0";
            scale = 1.0;
            transform = "90";
          }
        ];
      }
      {
        profile.name = "work-2-2025b";
        profile.outputs = [
          {
            criteria = "Dell Inc. DELL U3223QE C*";
            mode = "3840x2160";
            position = "2160,0";
            scale = 1.0;
            transform = "90";
          }
          {
            criteria = "Dell Inc. DELL UP3221Q H*";
            mode = "3840x2160";
            position = "4320,0";
            scale = 1.0;
            transform = "270";
          }
        ];
      }
      {
        profile.name = "work-2-2026H2";
        profile.outputs = [
          {
            criteria = "Dell Inc. DELL UP3221Q D*";
            mode = "3840x2160";
            position = "0,0";
            scale = 1.0;
            transform = "90";
          }
          {
            criteria = "Dell Inc. DELL UP3221Q H*";
            mode = "3840x2160";
            position = "2160,0";
            scale = 1.0;
            transform = "normal";
          }
        ];
      }
      {
        profile.name = "work-3";
        profile.outputs = [
          {
            criteria = "Sharp Corporation LQ*";
            mode = "3840x2400@59.99Hz";
            position = "-3840,0";
            scale = 1.5;
            status = "disable";
          }
          {
            criteria = "Dell Inc. DELL UP3221Q D*";
            mode = "3840x2160";
            position = "0,0";
            scale = 1.0;
            transform = "90";
          }
          {
            criteria = "Dell Inc. DELL U3223QE C*";
            mode = "3840x2160@60.00Hz";
            position = "2160,0";
            scale = 1.0;
            transform = "90";
          }
          {
            criteria = "Dell Inc. DELL UP3221Q H*";
            mode = "3840x2160@59.94Hz";
            position = "4320,0";
            scale = 1.0;
            transform = "270";
          }
        ];
      }
      {
        profile.name = "work-3-2025";
        profile.outputs = [
          {
            criteria = "Dell Inc. DELL UP3221Q D*";
            mode = "3840x2160";
            position = "0,0";
            scale = 1.0;
            transform = "90";
          }
          {
            criteria = "Dell Inc. DELL U3223QE C*";
            mode = "3840x2160";
            position = "2160,0";
            scale = 1.0;
            transform = "90";
          }
          {
            criteria = "Dell Inc. DELL UP3221Q H*";
            mode = "3840x2160";
            position = "4320,0";
            scale = 1.0;
            transform = "270";
          }
        ];
      }
      {
        profile.name = "work-vr";
        profile.outputs = [
          {
            criteria = "Sharp Corporation LQ*";
            mode = "3840x2400@59.99Hz";
            position = "0,0";
            scale = 1.5;
            status = "disable";
          }
          {
            criteria = "Dell Inc. DELL UP3221Q *";
            mode = "3840x2160@60.00Hz";
            position = "0,0";
            scale = 1.0;
            transform = "normal";
          }
          {
            criteria = "Visitech AS VITURE *";
            mode = "1920x1200@120.00Hz";
            position = "960,-1200";
            scale = 1.0;
            transform = "normal";
          }
        ];
      }
    ];
  };
}
