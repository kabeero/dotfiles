# ╭────────────╮
# │   kanshi   │
# ╰────────────╯

{ config, pkgs, ... }:

{
  services.kanshi = {
    enable = true;
    settings = [
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
    ];
  };
}
