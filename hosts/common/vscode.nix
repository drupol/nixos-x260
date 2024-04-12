{ pkgs
, self
, hostConfig
, config
, lib
, ...
}: {
  programs = {
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
        pkgs.vscode-extensions.christian-kohler.path-intellisense
        pkgs.vscode-extensions.coder.coder-remote
        pkgs.vscode-extensions.codezombiech.gitignore
        pkgs.vscode-extensions.devsense.phptools-vscode
        pkgs.vscode-extensions.dhall.vscode-dhall-lsp-server
        pkgs.vscode-extensions.dhall.dhall-lang
        pkgs.vscode-extensions.donjayamanne.githistory
        pkgs.vscode-extensions.editorconfig.editorconfig
        pkgs.vscode-extensions.esbenp.prettier-vscode
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
        pkgs.vscode-extensions.ms-vscode-remote.remote-containers
        pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
        pkgs.vscode-extensions.myriad-dreamin.tinymist
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
        "[jsonc]" = {
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
          "editor.defaultFormatter" = "jkillian.custom-local-formatters";
        };
        "[yaml]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };
        "customLocalFormatters.formatters" = [
          {
            "command" = "typstyle -i \${file}";
            "languages" = [
              "typst"
            ];
          }
        ];
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
  };
}
