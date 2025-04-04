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
      nix-your-shell = {
        enable = true;
        enableNushellIntegration = false;
        enableZshIntegration = false;
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
          format = "$directory$custom$php$rust$python$character";
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

          direnv = {
            format = " > [$symbol$version]($style)";
            version_format = "@\$\{raw\}";
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
            symbol = "py";
            format = " > [$symbol$version]($style)";
            version_format = "@\$\{raw\}";
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

          custom.jj = {
            when = "jj root --ignore-working-copy";
            format = " > $output";
            command = ''
              jj log -n 1 --ignore-working-copy --no-graph --color always -r @ -T '
                  surround(
                      "(",
                      ")",
                      separate(
                          " ",
                          parents.map(|parent| "~" ++ parent.local_bookmarks().join(" ")).join(" "),
                          coalesce(
                              surround(
                                  "\"",
                                  "\"",
                                  if(
                                      description.first_line().substr(0, 24).starts_with(description.first_line()),
                                      description.first_line().substr(0, 24),
                                      description.first_line().substr(0, 23) ++ "…"
                                  )
                              ),
                              "(no description set)"
                          ),
                          change_id.shortest(),
                          commit_id.shortest(),
                          if(conflict, "(conflict)"),
                          if(empty, "(empty)"),
                          if(divergent, "(divergent)"),
                          if(hidden, "(hidden)"),
                      )
                  )
              '
            '';
            detect_folders = [ ".jj" ];
          };
        };
      };
    };
  };
}
