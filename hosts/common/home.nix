{
  pkgs,
  self,
  host,
  config,
  ...
}: {
  home.stateVersion = "23.05";

  fonts = {fontconfig = {enable = true;};};

  home.file = {
    # See https://github.com/nix-community/home-manager/issues/1586#issuecomment-723843578
    ".mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json" = {
      source = "${pkgs.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";
      recursive = true;
    };
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
  };

  programs = {
    bat = {enable = true;};
    browserpass = {
      enable = true;
      browsers = ["firefox"];
    };
    command-not-found = {enable = false;};
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    exa = {enable = true;};
    firefox = {
      enable = true;
      extensions = [
        pkgs.nur.repos.rycee.firefox-addons.browserpass
        pkgs.nur.repos.rycee.firefox-addons.bypass-paywalls-clean
        pkgs.nur.repos.rycee.firefox-addons.enhancer-for-youtube
        pkgs.nur.repos.rycee.firefox-addons.french-dictionary
        pkgs.nur.repos.rycee.firefox-addons.i-dont-care-about-cookies
        pkgs.nur.repos.rycee.firefox-addons.kristofferhagen-nord-theme
        pkgs.nur.repos.rycee.firefox-addons.multi-account-containers
        pkgs.nur.repos.rycee.firefox-addons.plasma-integration
        pkgs.nur.repos.rycee.firefox-addons.privacy-badger
        pkgs.nur.repos.rycee.firefox-addons.tournesol
        pkgs.nur.repos.rycee.firefox-addons.youchoose-ai
      ];
      profiles.default = {
        id = 0;
        name = "Default";
        search = {
          default = "Google";
          force = true;
          engines = {
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
              definedAliases = ["@np"];
            };

            "NixOS Wiki" = {
              urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@nw"];
            };

            "Bing".metaData.hidden = true;
            "DuckDuckGo".metaData.hidden = true;
            "Amazon.nl".metaData.hidden = true;
            "eBay".metaData.hidden = true;
            "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
          };
        };
        settings = {
          # Browser settings go here
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
        };
      };
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      '';
      plugins = [
        {
          name = "bobthefish";
          src = pkgs.bobthefish-src;
        }
        {
          name = "z";
          src = pkgs.z-src;
        }
      ];
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        ll = "exa -lha";
        cat = "bat";
        ls = "exa";
        grep = "rg";
        man = "batman";
      };
    };
    git = {
      enable = true;
      difftastic = {enable = true;};
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
        branch = {autosetuprebase = "always";};
        color = {ui = "auto";};
        core = {
          autocrlf = "input";
          editor = "nano";
          safecrlf = "warn";
          excludesfile = "~/.gitignore_global";
        };
        diff = {mnemonicprefix = true;};
        init = {defaultBranch = "main";};
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
        rerere = {enabled = true;};
        include = {path = "~/.gitconfig.local";};
        signing = {
          signByDefault = true;
          key = "0AAF2901E8040715";
        };
        commit = {gpgsign = true;};
      };
    };
    home-manager = {enable = true;};
    htop = {enable = true;};
    password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = "${config.xdg.configHome}/.password-store";
      };
    };
    thunderbird = {
      enable = true;
      settings = {
        "general.useragent.override" = "";
        "privacy.donottrackheader.enabled" = true;
      };
      profiles = {
        default = {
          isDefault = true;
        };
      };
    };
    vscode = {
      enable = true;
      extensions = [
        pkgs.vscode-extensions.arcticicestudio.nord-visual-studio-code
        pkgs.vscode-extensions.b4dm4n.vscode-nixpkgs-fmt
        pkgs.vscode-extensions.bbenoist.nix
        pkgs.vscode-extensions.bmewburn.vscode-intelephense-client
        pkgs.vscode-extensions.brettm12345.nixfmt-vscode
        pkgs.vscode-extensions.bungcip.better-toml
        pkgs.vscode-extensions.christian-kohler.path-intellisense
        pkgs.vscode-extensions.codezombiech.gitignore
        pkgs.vscode-extensions.donjayamanne.githistory
        pkgs.vscode-extensions.editorconfig.editorconfig
        pkgs.vscode-extensions.esbenp.prettier-vscode
        pkgs.vscode-extensions.james-yu.latex-workshop
        pkgs.vscode-extensions.jebbs.plantuml
        pkgs.vscode-extensions.jnoortheen.nix-ide
        pkgs.vscode-extensions.matklad.rust-analyzer
        pkgs.vscode-extensions.mhutchie.git-graph
        pkgs.vscode-extensions.ms-vscode.makefile-tools
        pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
        pkgs.vscode-extensions.pkief.material-icon-theme
        pkgs.vscode-extensions.redhat.vscode-yaml
        pkgs.vscode-extensions.redhat.vscode-xml
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
        "[php]" = {
          "editor.defaultFormatter" = "bmewburn.vscode-intelephense-client";
        };
        "[yaml]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };
        "cSpell.language" = "fr,en-GB,en-US,en";
        "cSpell.minWordLength" = 3;
        "cSpell.userWords" = [];
        "cmake.configureOnOpen" = true;
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.bracketPairColorization.enabled" = true;
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.fontFamily" = "'Jetbrains mono'";
        "editor.fontLigatures" = true;
        "editor.guides.bracketPairs" = "active";
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
        "extensions.ignoreRecommendations" = true;
        "files.associations" = {
          "*.module" = "php";
        };
        "files.trimTrailingWhitespace" = true;
        "git.allowForcePush" = true;
        "git.autofetch" = true;
        "git.confirmForcePush" = false;
        "git.confirmSync" = false;
        "git.showPushSuccessNotification" = true;
        "gitblame.inlineMessageEnabled" = true;
        "gitblame.inlineMessageFormat" = "\${commit.summary} by \${author.name} - \${time.ago} @ \${commit.hash_short}";
        "gitblame.inlineMessageMargin" = 4;
        "gitblame.statusBarMessageFormat" = "\${commit.summary} by \${author.name} - \${time.ago} @ \${commit.hash_short}";
        "languageTool.language" = "fr";
        "languageToolLinter.serviceType" = "managed";
        "latex-workshop.latex.autoBuild.run" = "never";
        "latex-workshop.latex.external.build.command" = "make";
        "nix.formatterPath" = "alejandra";
        "nixEnvSelector.suggestion" = false;
        "php.suggest.basic" = false;
        "plantuml.previewSnapIndicators" = true;
        "redhat.telemetry.enabled" = false;
        "rest-client.enableTelemetry" = false;
        "rust-client.channel" = "stable";
        "rust-client.disableRustup" = true;
        "search.seedWithNearestWord" = true;
        "search.showLineNumbers" = true;
        "search.useGlobalIgnoreFiles" = true;
        "search.useIgnoreFiles" = true;
        "security.workspace.trust.untrustedFiles" = "open";
        "spellright.language" = [
          "en_US"
          "en"
        ];
        "sync.autoDownload" = true;
        "sync.autoUpload" = true;
        "sync.forceUpload" = true;
        "sync.gist" = "09e7759563df7cb7db0fbc04b9bb69c5";
        "sync.quietSync" = true;
        "telemetry.telemetryLevel" = "off";
        "terminal.integrated.defaultProfile.linux" = "fish";
        "terminal.integrated.fontSize" = 18;
        "window.dialogStyle" = "custom";
        "window.titleBarStyle" = "custom";
        "window.zoomLevel" = 1;
        "workbench.colorCustomizations" = {};
        "workbench.colorTheme" = "One Dark Pro Flat";
        "workbench.editor.highlightModifiedTabs" = true;
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.startupEditor" = "none";
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      sshKeys = ["143BC4FB7B3AC7C4F902ADCB579D2F66CDA1844A"];
    };
  };
}
