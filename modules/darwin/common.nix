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
    ./homebrew.nix
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nix;

    # Currently disabled `nix.settings.auto-optimise-store` as it seems to fail with remote builders
    # TODO renable when fixed https://github.com/NixOS/nix/issues/7273
    settings.auto-optimise-store = false;

    settings.experimental-features = "nix-command flakes";

    extraOptions = ''
      # needed for nix-direnv
      keep-outputs = true
      keep-derivations = true

      # assuming the builder has a faster internet connection
      builders-use-substitutes = true

      experimental-features = nix-command flakes
    '';
  };

  # Setup 1Password CLI `op`
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "1password-cli"
    ];

  security.pam.enableSudoTouchIdAuth = true;

  # can be read via `defaults read NSGlobalDomain`
  system.defaults.NSGlobalDomain = {
    InitialKeyRepeat = 15; # unit is 15ms, so 500ms
    KeyRepeat = 2; # unit is 15ms, so 30ms
    NSDocumentSaveNewDocumentsToCloud = false;
    ApplePressAndHoldEnabled = false;
    AppleShowScrollBars = "WhenScrolling";
    AppleShowAllExtensions = true;
  };
  system.defaults.dock.autohide = false;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

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

  system.stateVersion = 4;
}
