{ pkgs
, self
, hostConfig
, config
, lib
, ...
}: {
  imports = [
    ./firefox.nix
    ./git.nix
    ./lazygit.nix
    ./starship.nix
    ./vscode.nix
  ];

  home.stateVersion = "23.05";

  fonts = { fontconfig = { enable = true; }; };

  home.file = {
    ".face" = {
      source = ./. + "/../../files/home/pol/.face";
      recursive = true;
    };
    ".face.icon" = {
      source = ./. + "/../../files/home/pol/.face";
      recursive = true;
    };
    "${config.xdg.configHome}/.password-store/.keep" = {
      text = "";
      recursive = true;
    };
    "Code/" = {
      source = ./. + "/../../files/home/pol/Code/";
      recursive = true;
    };
    # Credits to https://store.kde.org/p/1272202
    "Pictures/Backgrounds/" = {
      source = ./. + "/../../files/home/pol/Pictures/Backgrounds/";
      recursive = true;
    };
    ".config/fish/conf.d/custom.fish" = {
      source = ./. + "/../../files/home/pol/.config/fish/conf.d/custom.fish";
      recursive = true;
    };
    ".config/birdtray-config.json" = {
      source = ./. + "/../../files/home/pol/.config/birdtray-config.json";
      recursive = true;
    };
  };

  programs = {
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch ];
    };
    bottom = {
      enable = true;
    };
    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };
    command-not-found = { enable = false; };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    eza = { enable = true; };
    fish = {
      enable = true;
      plugins = [
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair;
        }
      ];
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        cat = "bat";
        ls = "eza";
        grep = "rg";
        man = "batman";
      };
    };
    gh = {
      enable = true;
      extensions = [
        pkgs.master.gh-copilot
        pkgs.gh-dash
      ];
      settings = {
        version = "1";
        git_protocol = "ssh";
      };
    };
    gh-dash = {
      enable = true;
      settings = {
        prSections = [
          {
            title = "To review";
            filters = "repo:NixOS/nixpkgs is:open draft:false status:success";
          }
          {
            title = "1st contribution";
            filters = ''repo:NixOS/nixpkgs is:open draft:false label:"12. first-time contribution"'';
          }
          {
            title = "1st approval";
            filters = ''repo:NixOS/nixpkgs is:open draft:false status:success label:"12.approvals: 1"'';
          }
          {
            title = "From r-ryantm only";
            filters = ''repo:NixOS/nixpkgs is:open draft:false status:success base:master -label:"1.severity: mass-rebuild" -label:"1.severity: mass-darwin-rebuild"  author:r-ryantm'';
          }
          {
            title = "My PRs";
            filters = "is:open author:@me";
          }
          {
            title = "Needs my review";
            filters = "is:open review-requested:@me";
          }
          {
            title = "Involved";
            filters = "is:open involves:@me -author:@me";
          }
        ];
        defaults = {
          prsLimit = 50;
          issuesLimit = 10;
          view = "prs";
          preview = {
            open = false;
            width = 100;
          };
          refetchIntervalMinutes = 10;
        };
        keybindings = {
          prs = [
            {
              key = "v";
              command = "cd {{.RepoPath}} && code . && gh pr checkout {{.PrNumber}}";
            }
          ];
        };
        pager = {
          diff = "delta";
        };
        repoPaths = {
          "NixOS/*" = "~/Code/NixOS/*";
        };
        theme.ui.table.showSeparator = false;
      };
    };
    gpg = {
      enable = true;
      settings = {
        default-key = "0AAF2901E8040715";
      };
    };
    home-manager = { enable = true; };
    htop = { enable = true; };
    lazygit = { enable = true; };
    librewolf = {
      enable = true;
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };
    };
    micro = {
      enable = true;
    };
    password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = "${config.xdg.configHome}/.password-store";
      };
    };
    ripgrep = {
      enable = true;
    };
    thunderbird = {
      enable = true;
      settings = {
        "general.useragent.override" = "";
        "privacy.donottrackheader.enabled" = true;
        "network.dns.ipv4OnlyDomains" = "outlook.office365.com";
      };
      profiles = {
        default = {
          isDefault = true;
        };
      };
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      sshKeys = [ "143BC4FB7B3AC7C4F902ADCB579D2F66CDA1844A" ];
    };
  };
}
