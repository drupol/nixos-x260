{ pkgs
, self
, hostConfig
, config
, lib
, ...
}: {
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
    firefox = {
      enable = true;
      nativeMessagingHosts = [
        pkgs.plasma-browser-integration
        pkgs.browserpass
      ];
      profiles.default = {
        id = 0;
        isDefault = true;
        name = "Default";
        extensions = [
          pkgs.nur.repos.rycee.firefox-addons.browserpass
          # pkgs.nur.repos.rycee.firefox-addons.bypass-paywalls-clean
          pkgs.nur.repos.rycee.firefox-addons.enhancer-for-youtube
          pkgs.nur.repos.rycee.firefox-addons.private-relay
          pkgs.nur.repos.rycee.firefox-addons.foxyproxy-standard
          pkgs.nur.repos.rycee.firefox-addons.french-dictionary
          pkgs.nur.repos.rycee.firefox-addons.istilldontcareaboutcookies
          pkgs.nur.repos.rycee.firefox-addons.kristofferhagen-nord-theme
          pkgs.nur.repos.rycee.firefox-addons.languagetool
          pkgs.nur.repos.rycee.firefox-addons.multi-account-containers
          pkgs.nur.repos.rycee.firefox-addons.plasma-integration
          pkgs.nur.repos.rycee.firefox-addons.privacy-badger
          pkgs.nur.repos.rycee.firefox-addons.refined-saved-replies
          pkgs.nur.repos.rycee.firefox-addons.simple-tab-groups
          pkgs.nur.repos.rycee.firefox-addons.tournesol
        ];
        search = {
          default = "Google";
          force = true;
          engines = {
            "Autonomous-System-Number Search" = {
              urls = [{ template = "https://bgp.tools/search?q={searchTerms}"; }];
              iconUpdateURL = "https://bgp.tools/favicon-32x32.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@asn" ];
            };

            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "Nixpkgs PRs" = {
              urls = [{ template = "https://nixpk.gs/pr-tracker.html?pr={searchTerms}"; }];
              iconUpdateURL = "https://nixos.org/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@npr" ];
            };

            "NixOS Wiki" = {
              urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };

            "Noogle.dev Search" = {
              urls = [{ template = "https://noogle.dev/?term=%22{searchTerms}%22"; }];
              iconUpdateURL = "https://noogle.dev/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@ngd" "@nog" ];
            };

            "Bing".metaData.hidden = true;
            "DuckDuckGo".metaData.hidden = true;
            "Amazon.nl".metaData.hidden = true;
            "eBay".metaData.hidden = true;
            "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
          };
        };
        settings = {
          "browser.urlbar.update2.engineAliasRefresh" = true;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.startup.homepage" = "";
          # Enable HTTPS-Only Mode
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;
          # Privacy settings
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.partition.network_state.ocsp_cache" = true;
          # Disable all sorts of telemetry
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;

          # As well as Firefox 'experiments'
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.supported" = false;
          "network.allow-experiments" = false;
          # Disable Pocket Integration
          "browser.newtabpage.activity-stream.section.highlights.includePocket" =
            false;
          "extensions.pocket.enabled" = false;
          "extensions.pocket.api" = "";
          "extensions.pocket.oAuthConsumerKey" = "";
          "extensions.pocket.showHome" = false;
          "extensions.pocket.site" = "";
          # Allow copy to clipboard
          "dom.events.asyncClipboard.clipboardItem" = true;

          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "widget.use-xdg-desktop-portal.mime-handler" = 1;

          "privacy.donottrackheader.value" = 1;
          "browser.safebrowsing.malware.enabled" = false;
          "browser.search.hiddenOneOffs" = "Google,Yahoo,Bing,Amazon.com,Twitter";
          "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
          "browser.urlbar.trimURLs" = false;
          "findbar.modalHighlight" = true;
          "browser.fullscreen.autohide" = false;
          "browser.newtabpage.activity-stream.topSitesRows" = 0;
          "browser.urlbar.quickactions.enabled" = true;
        };
      };
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
    git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          navigate = true;
          side-by-side = true;
          line-numbers = true;
          decorations = true;
          syntax-theme = "OneHalfDark";
        };
      };
      userName = "Pol Dellaiera";
      userEmail = "pol.dellaiera@protonmail.com";
      aliases = {
        ll = "log --stat --abbrev-commit";
        co = "checkout";
        patch = "format-patch --stdout HEAD~1";
        rpatch = "reset --hard HEAD~1";
        lgg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
        lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        clb = "!/home/user/bin/git-clean-local-branches";
        pf = "push --force-with-lease";
        rewrite = "rebase - x 'git commit - -amend - C HEAD - -date=\"$(date -R)\" && sleep 1.05'";
        # From https://gist.github.com/pksunkara/988716
        a = "add --all";
        ai = "add -i";
        #############
        ap = "apply";
        as = "apply --stat";
        ac = "apply --check";
        #############
        ama = "am --abort";
        amr = "am --resolved";
        ams = "am --skip";
        #############
        b = "branch";
        ba = "branch -a";
        bd = "branch -d";
        bdd = "branch -D";
        br = "branch -r";
        bc = "rev-parse --abbrev-ref HEAD";
        bu = ''!git rev-parse --abbrev-ref --symbolic-full-name "@{u}"'';
        recent-branches = "branch --sort=-committerdate";
        #############
        c = "commit";
        ca = "commit -a";
        cm = "commit -m";
        cam = "commit -am";
        cem = "commit --allow-empty -m";
        cd = "commit --amend";
        cad = "commit -a --amend";
        ced = "commit --allow-empty --amend";
        #############
        cl = "clone";
        cld = "clone --depth 1";
        clg = "!sh -c 'git clone git://github.com/$1 $(basename $1)' -";
        clgp = "!sh -c 'git clone git@github.com:$(git config --get user.username)/$1 $1' -";
        #############
        co-pr = "!sh -c 'git fetch origin refs/pull/$1/head:pull/$1 && git checkout pull/$1' -";
        cp = "cherry-pick";
        cpa = "cherry-pick --abort";
        cpc = "cherry-pick --continue";
        #############
        d = "diff";
        dp = "diff --patience";
        dc = "diff --cached";
        dk = "diff --check";
        dck = "diff --cached --check";
        dt = "difftool";
        dct = "difftool --cached";
        #############
        f = "fetch";
        fo = "fetch origin";
        fu = "fetch upstream";
        #############
        fp = "format-patch";
        #############
        fk = "fsck";
        #############
        g = "grep -p";
        #############
        l = "log --oneline";
        lg = "log --oneline --graph --decorate";
        #############
        ls = "ls-files";
        lsf = "!git ls-files | grep -i";
        #############
        m = "merge";
        ma = "merge --abort";
        mc = "merge --continue";
        ms = "merge --skip";
        #############
        o = "checkout";
        ob = "checkout -b";
        #############
        pr = "prune -v";
        #############
        ps = "push";
        psf = "push -f";
        psu = "push -u";
        pst = "push --tags";
        #############
        pso = "push origin";
        psao = "push --all origin";
        psfo = "push -f origin";
        psuo = "push -u origin";
        #############
        psom = "push origin master";
        psaom = "push --all origin master";
        psfom = "push -f origin master";
        psuom = "push -u origin master";
        psoc = "!git push origin $(git bc)";
        psaoc = "!git push --all origin $(git bc)";
        psfoc = "!git push -f origin $(git bc)";
        psuoc = "!git push -u origin $(git bc)";
        psdc = "!git push origin :$(git bc)";
        #############
        pl = "pull";
        pb = "pull --rebase";
        #############
        plo = "pull origin";
        pbo = "pull --rebase origin";
        plom = "pull origin master";
        ploc = "!git pull origin $(git bc)";
        pbom = "pull --rebase origin master";
        pboc = "!git pull --rebase origin $(git bc)";
        #############
        plu = "pull upstream";
        plum = "pull upstream master";
        pluc = "!git pull upstream $(git bc)";
        pbum = "pull --rebase upstream master";
        pbuc = "!git pull --rebase upstream $(git bc)";
        #############
        rb = "rebase";
        rba = "rebase --abort";
        rbc = "rebase --continue";
        rbi = "rebase --interactive";
        rbs = "rebase --skip";
        #############
        re = "reset";
        rh = "reset HEAD";
        reh = "reset --hard";
        rem = "reset --mixed";
        res = "reset --soft";
        rehh = "reset --hard HEAD";
        remh = "reset --mixed HEAD";
        resh = "reset --soft HEAD";
        #############
        r = "remote";
        ra = "remote add";
        rr = "remote rm";
        rv = "remote -v";
        rn = "remote rename";
        rp = "remote prune";
        rs = "remote show";
        rao = "remote add origin";
        rau = "remote add upstream";
        rro = "remote remove origin";
        rru = "remote remove upstream";
        rso = "remote show origin";
        rsu = "remote show upstream";
        rpo = "remote prune origin";
        rpu = "remote prune upstream";
        #############
        rmf = "rm -f";
        rmrf = "rm -r -f";
        #############
        s = "status";
        sb = "status -s -b";
        #############
        sa = "stash apply";
        sc = "stash clear";
        sd = "stash drop";
        sl = "stash list";
        sp = "stash pop";
        ss = "stash save";
        ssk = "stash save -k";
        sw = "stash show";
        st = "!git stash list | wc -l 2>/dev/null | grep -oEi '[0-9][0-9]*'";
        #############
        t = "tag";
        td = "tag -d";
        #############
        w = "show";
        wp = "show -p";
        wr = "show -p --no-color";
        #############
        subadd = "!sh -c 'git submodule add git://github.com/$1 $2/$(basename $1)' -";
        subup = "submodule update --init --recursive";
        subpull = "!git submodule foreach git pull --tags origin master";
        #############
        assume = "update-index --assume-unchanged";
        unassume = "update-index --no-assume-unchanged";
        assumed = "!git ls -v | grep ^h | cut -c 3-";
        unassumeall = "!git assumed | xargs git unassume";
        assumeall = "!git status -s | awk {'print $2'} | xargs git assume";
        #############
        bump = ''
          !sh -c 'git commit -am "Version bump v$1" && git psuoc && git release $1' -'';
        release = "!sh -c 'git tag v$1 && git pst' -";
        unrelease = "!sh -c 'git tag -d v$1 && git pso :v$1' -";
        merged = "!sh -c 'git o master && git plom && git bd $1 && git rpo' -";
        aliases = "!git config -l | grep alias | cut -c 7-";
        snap = "!git stash save 'snapshot = $(date)' && git stash apply 'stash@{0}'";
        bare = "!sh -c 'git symbolic-ref HEAD refs/heads/$1 && git rm --cached -r . && git clean -xfd' -";
        whois = ''
          !sh -c 'git log -i -1 --author="$1" --pretty="format:%an <%ae>"' -'';
        serve = "daemon --reuseaddr --verbose --base-path=. --export-all ./.git";
        #############
        behind = "!git rev-list --left-only --count $(git bu)...HEAD";
        ahead = "!git rev-list --right-only --count $(git bu)...HEAD";
        #############
        ours = "!f() { git checkout --ours $@ && git add $@; }; f";
        theirs = "!f() { git checkout --theirs $@ && git add $@; }; f";
        subrepo = "!sh -c 'git filter-branch --prune-empty --subdirectory-filter $1 master' -";
        human = "name-rev --name-only --refs=refs/heads/*";
      };
      extraConfig = {
        branch = { autosetuprebase = "always"; };
        color = { ui = "auto"; };
        core = {
          autocrlf = "input";
          editor = "micro";
          safecrlf = "warn";
          excludesfile = "~/.gitignore_global";
        };
        diff = { mnemonicprefix = true; };
        include = { path = "~/.gitconfig.local"; };
        init = { defaultBranch = "main"; };
        merge = {
          conflictstyle = "diff3";
          commit = "no";
          ff = "no";
          tool = "splice";
        };
        push = {
          autoSetupRemote = true;
          default = "current";
        };
        pull = {
          default = "matching";
          rebase = true;
        };
        rebase = {
          instructionFormat = "(%an <%ae>) %s";
          updateRefs = true;
        };
        rerere = { enabled = true; };
        sequence = {
          editor = "code --wait";
        };
        signing = {
          signByDefault = true;
          key = "0AAF2901E8040715";
        };
        commit = { gpgsign = true; };
      };
    };
    gpg = {
      enable = true;
      settings = {
        default-key = "0AAF2901E8040715";
      };
    };
    helix = {
      enable = true;
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
    vscode = {
      enable = true;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      mutableExtensionsDir = false;
      extensions = [
        pkgs.vscode-extensions.arcticicestudio.nord-visual-studio-code
        pkgs.vscode-extensions.b4dm4n.vscode-nixpkgs-fmt
        pkgs.vscode-extensions.bbenoist.nix
        pkgs.vscode-extensions.bmewburn.vscode-intelephense-client
        pkgs.vscode-extensions.brettm12345.nixfmt-vscode
        pkgs.vscode-extensions.chris-hayes.chatgpt-reborn
        pkgs.vscode-extensions.christian-kohler.path-intellisense
        pkgs.vscode-extensions.codezombiech.gitignore
        pkgs.vscode-extensions.devsense.phptools-vscode
        pkgs.vscode-extensions.dhall.vscode-dhall-lsp-server
        pkgs.vscode-extensions.dhall.dhall-lang
        pkgs.vscode-extensions.donjayamanne.githistory
        pkgs.vscode-extensions.editorconfig.editorconfig
        pkgs.vscode-extensions.esbenp.prettier-vscode
        pkgs.vscode-extensions.genieai.chatgpt-vscode
        pkgs.vscode-extensions.github.copilot
        pkgs.vscode-extensions.github.copilot-chat
        pkgs.vscode-extensions.github.github-vscode-theme
        pkgs.vscode-extensions.github.vscode-pull-request-github
        pkgs.vscode-extensions.griimick.vhs
        pkgs.vscode-extensions.james-yu.latex-workshop
        pkgs.vscode-extensions.jebbs.plantuml
        pkgs.vscode-extensions.jkillian.custom-local-formatters
        pkgs.vscode-extensions.jnoortheen.nix-ide
        pkgs.vscode-extensions.matklad.rust-analyzer
        pkgs.vscode-extensions.mgt19937.typst-preview
        pkgs.vscode-extensions.mhutchie.git-graph
        pkgs.vscode-extensions.mkhl.direnv
        pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
        pkgs.vscode-extensions.nvarner.typst-lsp
        pkgs.vscode-extensions.pkief.material-icon-theme
        pkgs.vscode-extensions.redhat.vscode-yaml
        pkgs.vscode-extensions.redhat.vscode-xml
        pkgs.vscode-extensions.rust-lang.rust-analyzer
        pkgs.vscode-extensions.tailscale.vscode-tailscale
        pkgs.vscode-extensions.tamasfe.even-better-toml
        pkgs.vscode-extensions.usernamehw.errorlens
        pkgs.vscode-extensions.waderyan.gitblame
        pkgs.vscode-extensions.yzhang.markdown-all-in-one
        pkgs.vscode-extensions.zhuangtongfa.material-theme
      ];
      userSettings = {
        "[json]" = {
          "editor.defaultFormatter" = "vscode.json-language-features";
        };
        "[markdown]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[nix]" = {
          "editor.defaultFormatter" = "brettm12345.nixfmt-vscode";
        };
        "[rust]" = {
          "editor.defaultFormatter" = "rust-lang.rust-analyzer";
        };
        "[php]" = {
          "editor.defaultFormatter" = "bmewburn.vscode-intelephense-client";
        };
        "[toml]" = {
          "editor.defaultFormatter" = "bungcip.better-toml";
        };
        "[txt]" = {
          "editor.formatOnSave" = false;
        };
        "[typst]" = {
          "editor.defaultFormatter" = "nvarner.typst-lsp";
        };
        "[yaml]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };
        "chatgpt.promptPrefix.customPrompt1" = "Pourrais-tu améliorer le texte suivant?";
        "chatgpt.promptPrefix.customPrompt2" = "Could you improve the following text?";
        "chatgpt.promptPrefix.customPrompt1-enabled" = true;
        "chatgpt.promptPrefix.customPrompt2-enabled" = true;
        "chatgpt.gpt3.model" = "gpt-4";
        "chatgpt.telemetry.disable" = true;
        "chatgpt.response.showNotification" = true;
        "debug.console.fontFamily" = "'Iosevka Comfy'";
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.bracketPairColorization.enabled" = true;
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.fontFamily" = "'Iosevka Comfy'";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 14;
        "editor.formatOnSave" = false;
        "editor.suggestFontSize" = 0;
        "editor.suggest.preview" = true;
        "editor.suggest.showStatusBar" = true;
        "editor.guides.bracketPairs" = "active";
        "editor.inlineSuggest.enabled" = true;
        "editor.mouseWheelZoom" = true;
        "editor.rulers" = [
          80
          120
        ];
        "editor.stickyScroll.enabled" = true;
        "editor.stickyScroll.maxLineCount" = 10;
        "editor.suggestSelection" = "first";
        "editor.unicodeHighlight.ambiguousCharacters" = false;
        "editor.unicodeHighlight.invisibleCharacters" = false;
        "editor.unicodeHighlight.nonBasicASCII" = false;
        "errorLens.enabled" = false;
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "extensions.autoCheckUpdates" = true;
        "extensions.autoUpdate" = false;
        "extensions.ignoreRecommendations" = true;
        "files.associations" = {
          "*.module" = "php";
        };
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 500;
        "files.insertFinalNewline" = true;
        "files.trimFinalNewlines" = true;
        "files.trimTrailingWhitespace" = true;
        "git.allowForcePush" = true;
        "git.autofetch" = true;
        "git.autoStash" = true;
        "git.confirmForcePush" = false;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "git.showPushSuccessNotification" = true;
        "gitblame.inlineMessageEnabled" = true;
        "gitblame.inlineMessageFormat" = "\${commit.summary} by \${author.name} - \${time.ago} @ \${commit.hash_short}";
        "gitblame.inlineMessageMargin" = 4;
        "gitblame.statusBarMessageFormat" = "\${commit.summary} by \${author.name} - \${time.ago} @ \${commit.hash_short}";
        "github.copilot.enable" = {
          "*" = true;
          "yaml" = true;
          "plaintext" = true;
          "markdown" = true;
        };
        "githubPullRequests.pullBranch" = "always";
        "gitlens.codeLens.enabled" = false;
        "gitlens.rebaseEditor.ordering" = "asc";
        "latex-workshop.latex.autoBuild.run" = "never";
        "latex-workshop.view.pdf.viewer" = "tab";
        "markdown.preview.fontFamily" = "'Iosevka Comfy'";
        "nix.formatterPath" = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
        "nix.enableLanguageServer" = true;
        "nix.serverSettings.nil.formatting.command" = [ "nixpkgs-fmt" ];
        "nixfmt.path" = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
        "php.suggest.basic" = false;
        "php.validate.executablePath" = "";
        "plantuml.previewSnapIndicators" = true;
        "plantuml.render" = "PlantUMLServer";
        "plantuml.server" = "https://www.plantuml.com/plantuml";
        "redhat.telemetry.enabled" = false;
        "search.seedWithNearestWord" = true;
        "search.showLineNumbers" = true;
        "search.useGlobalIgnoreFiles" = true;
        "search.useIgnoreFiles" = true;
        "search.exclude" = {
          "**/.direnv" = true;
          "**/.git" = true;
          "**/node_modules" = true;
          "*.lock" = true;
          "dist" = true;
          "tmp" = true;
        };
        "security.workspace.trust.untrustedFiles" = "open";
        "telemetry.telemetryLevel" = "off";
        "terminal.integrated.defaultProfile.linux" = "fish";
        "terminal.integrated.fontSize" = 14;
        "typst-lsp.exportPdf" = "never";
        "typst-lsp.experimentalFormatterMode" = "on";
        "rust-analyzer.serverPath" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        "rust-analyzer.cargo.buildScripts.enable" = true;
        "update.mode" = "manual";
        "update.showReleaseNotes" = false;
        "window.dialogStyle" = "custom";
        "window.menuBarVisibility" = "toggle";
        "window.newWindowDimensions" = "inherit";
        "window.titleBarStyle" = "custom";
        "window.zoomLevel" = 0;
        "workbench.colorCustomizations" = { };
        "workbench.colorTheme" = "GitHub Dark Default";
        "workbench.editor.highlightModifiedTabs" = true;
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.startupEditor" = "none";
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
