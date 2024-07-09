{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shell;
in
{
  imports = [ ];

  options = {
    shell = {
      enable = lib.mkEnableOption "shell";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.enable = true;
    xdg.mime.enable = true;

    programs = {
      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
          batgrep
          batwatch
        ];
      };
      bottom = {
        enable = true;
      };
      command-not-found = {
        enable = false;
      };
      direnv = {
        enable = true;
        config = {
          global = {
            hide_env_diff = true;
          };
        };
        nix-direnv.enable = true;
      };
      eza = {
        enable = true;
      };
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
        functions = {
          fish_greeting = "";
        };
      };
      fzf = {
        enable = true;
      };
      htop = {
        enable = true;
      };
      ripgrep = {
        enable = true;
      };
      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };
      starship = {
        enable = true;
        enableTransience = true;
        settings = {
          add_newline = false;
          command_timeout = 5000;
          scan_timeout = 1;
          format = "$directory$git_branch$git_commit$git_state$git_metrics$git_status$php$rust$character";
          right_format = "$username$hostname$localip$nix_shell$cmd_duration$os";
          character = {
            success_symbol = " [❯](bold green)";
            error_symbol = " [✘](bold red)";
            vimcmd_symbol = " [❮](bold green)";
          };

          aws = {
            symbol = "aws ";
          };

          azure = {
            symbol = "az ";
          };

          bun = {
            symbol = "bun ";
          };

          c = {
            symbol = "C ";
          };

          cobol = {
            symbol = "cobol ";
          };

          cmd_duration = {
            min_time = 1000;
            format = "[$duration]($style) | ";
            style = "yellow bold";
            show_milliseconds = true;
            disabled = false;
            show_notifications = true;
            min_time_to_notify = 45000;
          };

          conda = {
            symbol = "conda ";
          };

          crystal = {
            symbol = "cr ";
          };

          cmake = {
            symbol = "cmake ";
          };

          daml = {
            symbol = "daml ";
          };

          dart = {
            symbol = "dart ";
          };

          deno = {
            symbol = "deno ";
          };

          dotnet = {
            symbol = ".NET ";
          };

          directory = {
            format = "[$path]($style)[$read_only]($read_only_style)";
            read_only = " ro";
            home_symbol = "~";
            fish_style_pwd_dir_length = 1;
          };

          docker_context = {
            symbol = "docker ";
          };

          elixir = {
            symbol = "exs ";
          };

          elm = {
            symbol = "elm ";
          };

          fennel = {
            symbol = "fnl ";
          };

          fossil_branch = {
            symbol = "fossil ";
          };

          gcloud = {
            symbol = "gcp ";
          };

          git_branch = {
            symbol = ">";
            format = " $symbol $branch(:$remote_branch)";
          };

          git_commit = {
            commit_hash_length = 7;
            format = " > ([\($hash$tag\)]($style))";
            style = "green bold";
            only_detached = true;
            disabled = false;
            tag_symbol = "@";
            tag_disabled = false;
            tag_max_candidates = 0;
          };

          git_metrics = {
            added_style = "bold green";
            deleted_style = "bold red";
            only_nonzero_diffs = true;
            format = "( [+$added]($added_style) )([-$deleted]($deleted_style))";
            disabled = false;
            ignore_submodules = false;
          };

          git_status = {
            format = "( \[\\[$all_status$ahead_behind\\]\]\($style\))";
            style = "red bold";
            ahead = "↑";
            behind = "↓";
            conflicted = "✖";
            deleted = "x";
            diverged = "⇅";
            modified = "!";
            renamed = "r";
            staged = "+";
            stashed = "";
            untracked = "?";
          };

          golang = {
            symbol = "go";
            format = " > [$symbol$version]($style)";
            version_format = "@\$\{raw\}";
          };

          gradle = {
            symbol = "gradle ";
          };

          guix_shell = {
            symbol = "guix ";
          };

          hg_branch = {
            symbol = "hg ";
          };

          hostname = {
            ssh_only = true;
            format = "@[$hostname](bold red) | ";
            disabled = false;
          };

          java = {
            symbol = "java ";
          };

          julia = {
            symbol = "jl ";
          };

          kotlin = {
            symbol = "kt ";
          };

          localip = {
            ssh_only = false;
            format = "[$localipv4](bold red) | ";
            disabled = false;
          };

          lua = {
            symbol = "lua ";
          };

          nodejs = {
            symbol = "node";
            format = " > [$symbol$version]($style)";
            version_format = "@\$\{raw\}";
          };

          memory_usage = {
            symbol = "memory ";
          };

          meson = {
            symbol = "meson ";
          };

          nim = {
            symbol = "nim ";
          };

          nix_shell = {
            format = "[$symbol$state( \($name\))]($style) | ";
            symbol = "";
            style = "bold blue";
            impure_msg = "impure";
            pure_msg = "pure";
            unknown_msg = "";
            disabled = false;
            heuristic = true;
          };

          ocaml = {
            symbol = "ml ";
          };

          opa = {
            symbol = "opa ";
          };

          os = {
            format = "[$symbol]($style)";
            style = "bold white";
            disabled = false;
            symbols = {
              Alpaquita = "alq";
              Alpine = "alp";
              Amazon = "amz";
              Android = "andr";
              Arch = "rch";
              Artix = "atx";
              CentOS = "cent";
              Debian = "deb";
              DragonFly = "dfbsd";
              Emscripten = "emsc";
              EndeavourOS = "ndev";
              Fedora = "fed";
              FreeBSD = "fbsd";
              Garuda = "garu";
              Gentoo = "gentoo";
              HardenedBSD = "hbsd";
              Illumos = "lum";
              Linux = "lnx";
              Mabox = "mbox";
              Macos = "mac";
              Manjaro = "mjo";
              Mariner = "mrn";
              MidnightBSD = "mid";
              Mint = "mint";
              NetBSD = "nbsd";
              NixOS = "❄️";
              OpenBSD = "obsd";
              OpenCloudOS = "ocos";
              openEuler = "oeul";
              openSUSE = "osuse";
              OracleLinux = "orac";
              Pop = "pop";
              Raspbian = "rasp";
              Redhat = "rhl";
              RedHatEnterprise = "rhel";
              Redox = "redox";
              Solus = "sol";
              SUSE = "suse";
              Ubuntu = "ubnt";
              Unknown = "unk";
              Windows = "win";
            };
          };

          package = {
            symbol = "pkg ";
          };

          perl = {
            symbol = "pl ";
          };

          php = {
            symbol = "php";
            format = " > [$symbol$version]($style)";
            version_format = "@\$\{raw\}";
          };

          pijul_channel = {
            symbol = "pijul ";
          };

          pulumi = {
            symbol = "pulumi ";
          };

          purescript = {
            symbol = "purs ";
          };

          python = {
            symbol = "py ";
          };

          raku = {
            symbol = "raku ";
          };

          ruby = {
            symbol = "rb ";
          };

          rust = {
            symbol = "rust";
            format = " > [$symbol$version]($style)";
            version_format = "@\$\{raw\}";
          };

          scala = {
            symbol = "scala ";
          };

          spack = {
            symbol = "spack ";
          };

          solidity = {
            symbol = "solidity ";
          };

          status = {
            symbol = "[x](bold red) ";
          };

          sudo = {
            symbol = "sudo ";
          };

          swift = {
            symbol = "swift ";
          };

          terraform = {
            symbol = "terraform ";
          };

          username = {
            format = "$user";
            style_root = "red bold";
            style_user = "yellow bold";
            show_always = false;
            disabled = false;
          };

          vagrant = {
            symbol = "vagrant ";
          };

          zig = {
            symbol = "zig ";
          };
        };
      };
    };
  };
}
