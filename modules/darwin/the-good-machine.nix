{
  pkgs,
  config,
  lib,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # environment.systemPackages =
  #   [ pkgs.vim
  #   ];

  imports = [
    ./../common
    ./common.nix
  ];

  # Setup 1Password CLI `op`
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "1password-cli"
    ];

  programs = {
    fish.enable = true;
  };

  environment.shells = [pkgs.fish];

  users.users.${config.user} = {
    home = "/Users/${config.user}";
    shell = "${pkgs.fish}/bin/fish";
  };
  users.users.root = {
    home = "/var/root";
    shell = "${pkgs.fish}/bin/fish";
  };

  fonts = {
    fontDir.enable = true;
    fonts = [
      pkgs.inter
      (pkgs.nerdfonts.override {
        fonts = [
          "FiraCode"
          "FiraMono"
          "JetBrainsMono"
          "SourceCodePro"
        ];
      })
    ];
  };
}
