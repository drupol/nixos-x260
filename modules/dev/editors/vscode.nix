{
  inputs,
  lib,
  ...
}:
{
  flake.modules = {
    nixos.dev = {
      services = {
        # needed for store VS Code auth token
        gnome.gnome-keyring.enable = true;
      };
    };

    homeManager.dev =
      { pkgs, ... }:
      {
        nixpkgs = {
          overlays = [
            (final: prev: {
              master = import inputs.nixpkgs-master {
                inherit (final) config system;
              };
            })
          ];
        };

        home.packages = with pkgs; [
          vscode-runner
        ];

        programs.vscode = {
          enable = true;
          mutableExtensionsDir = false;
          profiles = {
            default = {
              enableExtensionUpdateCheck = false;
              enableUpdateCheck = false;
              extensions = [
                pkgs.vscode-extensions.anweber.vscode-httpyac
                pkgs.vscode-extensions.arcticicestudio.nord-visual-studio-code
                pkgs.vscode-extensions.bbenoist.nix
                pkgs.vscode-extensions.bmewburn.vscode-intelephense-client
                pkgs.vscode-extensions.charliermarsh.ruff
                pkgs.vscode-extensions.christian-kohler.path-intellisense
                pkgs.vscode-extensions.coder.coder-remote
                pkgs.vscode-extensions.codezombiech.gitignore
                pkgs.vscode-extensions.dhall.vscode-dhall-lsp-server
                pkgs.vscode-extensions.dhall.dhall-lang
                pkgs.vscode-extensions.donjayamanne.githistory
                pkgs.vscode-extensions.editorconfig.editorconfig
                pkgs.vscode-extensions.esbenp.prettier-vscode

                pkgs.vscode-extensions.github.copilot
                pkgs.vscode-extensions.github.copilot-chat

                pkgs.vscode-extensions.github.github-vscode-theme
                pkgs.vscode-extensions.github.vscode-pull-request-github
                pkgs.vscode-extensions.golang.go
                pkgs.vscode-extensions.jebbs.plantuml
                pkgs.vscode-extensions.jnoortheen.nix-ide
                pkgs.vscode-extensions.mkhl.direnv
                pkgs.vscode-extensions.mongodb.mongodb-vscode

                pkgs.vscode-extensions.ms-python.debugpy
                pkgs.vscode-extensions.ms-python.mypy-type-checker
                pkgs.vscode-extensions.ms-python.python
                pkgs.vscode-extensions.ms-python.vscode-pylance

                pkgs.vscode-extensions.ms-toolsai.jupyter
                pkgs.vscode-extensions.ms-vscode-remote.remote-containers
                pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
                pkgs.vscode-extensions.ms-vsliveshare.vsliveshare
                pkgs.vscode-extensions.myriad-dreamin.tinymist
                pkgs.vscode-extensions.pkief.material-icon-theme
                pkgs.vscode-extensions.redhat.vscode-yaml
                pkgs.vscode-extensions.redhat.vscode-xml
                pkgs.vscode-extensions.rust-lang.rust-analyzer
                pkgs.vscode-extensions.tamasfe.even-better-toml
                pkgs.vscode-extensions.tekumara.typos-vscode
                pkgs.vscode-extensions.usernamehw.errorlens

                pkgs.vscode-extensions.visualjj.visualjj

                pkgs.vscode-extensions.yzhang.markdown-all-in-one
                pkgs.vscode-extensions.zhuangtongfa.material-theme
              ];
              userSettings = {
                "[css]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[go]" = {
                  "editor.defaultFormatter" = "golang.go";
                };
                "[graphql]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[handlebars]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[html]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[javascript]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[javascriptreact]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[json]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[jsonc]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[json5]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[less]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[markdown]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[mdx]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[nix]" = {
                  "editor.defaultFormatter" = "jnoortheen.nix-ide";
                };
                "[php]" = {
                  "editor.defaultFormatter" = "bmewburn.vscode-intelephense-client";
                };
                "[postcss]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[scss]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[toml]" = {
                  "editor.defaultFormatter" = "tamasfe.even-better-toml";
                };
                "[txt]" = {
                  "editor.formatOnSave" = false;
                };
                "[typescript]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[typescriptreact]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[typst]" = {
                  "editor.defaultFormatter" = "myriad-dreamin.tinymist";
                };
                "[vue]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[yaml]" = {
                  "editor.defaultFormatter" = "redhat.vscode-yaml";
                };
                "debug.console.fontFamily" = "'Aporetic Sans Mono'";
                "diffEditor.ignoreTrimWhitespace" = false;
                "editor.bracketPairColorization.enabled" = true;
                "editor.cursorSmoothCaretAnimation" = "on";
                "editor.fontFamily" = "'Aporetic Sans Mono'";
                "editor.fontLigatures" = true;
                "editor.fontSize" = 14;
                "editor.formatOnSave" = false;
                "editor.guides.bracketPairs" = true;
                "editor.inlineSuggest.enabled" = true;
                "editor.inlineSuggest.edits" = {
                  renderSideBySide = true;
                };
                "editor.renderWhitespace" = "boundary";
                "editor.suggestFontSize" = 0;
                "editor.suggest.preview" = true;
                "editor.suggest.showStatusBar" = true;
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
                "explorer.fileNesting.enabled" = true;
                "explorer.fileNesting.patterns" = {
                  "*.md" = "\${capture}.*.md";
                  "config.toml" = "config.*.toml,params.toml";
                };
                "extensions.autoCheckUpdates" = false;
                "extensions.autoUpdate" = false;
                "extensions.ignoreRecommendations" = true;
                "files.autoSave" = "afterDelay";
                "files.autoSaveDelay" = 500;
                "files.insertFinalNewline" = true;
                "files.trimFinalNewlines" = true;
                "files.trimTrailingWhitespace" = true;
                "git.allowForcePush" = true;
                "git.autofetch" = true;
                "git.autoStash" = true;
                "git.blame.editorDecoration.enabled" = true;
                "git.blame.statusBarItem.enabled" = true;
                "git.blame.editorDecoration.template" = "\${subject}, \${authorName} (\${authorDateAgo})";
                "git.blame.statusBarItem.template" = "\${subject}, \${authorName} (\${authorDateAgo})";
                "git.confirmForcePush" = false;
                "git.confirmSync" = false;
                "git.enableSmartCommit" = true;
                "git.showPushSuccessNotification" = true;
                "github.copilot.nextEditSuggestions" = true;
                "github.copilot.enable" = {
                  "*" = true;
                  yaml = true;
                  plaintext = true;
                  markdown = true;
                };
                "githubPullRequests.pullBranch" = "always";
                "markdown.preview.fontFamily" = "'Aporetic Sans Mono'";
                "nix.formatterPath" = [ (lib.getExe pkgs.nixfmt-rfc-style) ];
                "nix.serverPath" = lib.getExe pkgs.nixd;
                "nix.enableLanguageServer" = true;
                "nix.serverSettings".nixd.formatting.command = [ (lib.getExe pkgs.nixfmt-rfc-style) ];
                "plantuml.previewSnapIndicators" = true;
                "plantuml.render" = "Local";
                "plantuml.server" = "https://www.plantuml.com/plantuml";
                "python.analysis.autoImportCompletions" = true;
                "redhat.telemetry.enabled" = false;
                "search.seedWithNearestWord" = true;
                "search.showLineNumbers" = true;
                "search.useGlobalIgnoreFiles" = true;
                "search.useIgnoreFiles" = true;
                "search.exclude" = {
                  "**/.direnv" = true;
                  "**/.git" = true;
                  "**/.jj" = true;
                  "**/.venv" = true;
                  "**/node_modules" = true;
                  "*.lock" = true;
                  "dist" = true;
                  "tmp" = true;
                };
                "security.workspace.trust.untrustedFiles" = "open";
                "telemetry.telemetryLevel" = "off";
                "terminal.integrated.defaultProfile.linux" = "fish";
                "terminal.integrated.fontSize" = 14;
                "terminal.integrated.tabs.enabled" = true;
                "tinymist.preview.scrollSync" = "onSelectionChange";
                "tinymist.formatterMode" = "typstyle";
                "update.mode" = "none";
                "update.showReleaseNotes" = true;
                "window.dialogStyle" = "custom";
                "window.menuBarVisibility" = "toggle";
                "window.newWindowDimensions" = "inherit";
                "window.titleBarStyle" = "custom";
                "window.zoomLevel" = 0;
                "workbench.colorCustomizations" = { };
                "workbench.colorTheme" = "GitHub Dark Default";
                "workbench.commandPalette.experimental.suggestCommands" = true;
                "workbench.editor.enablePreview" = false; # Prevents temporary editor tabs
                "workbench.editor.highlightModifiedTabs" = true;
                "workbench.iconTheme" = "material-icon-theme";
                "workbench.panel.defaultLocation" = "bottom";
                "workbench.startupEditor" = "none";
              };
            };
          };
        };
      };
  };

  nixpkgs = {
    allowedUnfreePackages = [
      "vscode"
      "vscode-extension-bmewburn-vscode-intelephense-client"
      "vscode-extension-github-copilot"
      "vscode-extension-github-copilot-chat"
      "vscode-extension-MS-python-vscode-pylance"
      "vscode-extension-ms-vscode-remote-remote-containers"
      "vscode-extension-ms-vscode-remote-remote-ssh"
      "vscode-extension-ms-vsliveshare-vsliveshare"
      "vscode-extension-visualjj-visualjj"
    ];
  };
}
