{
  inputs,
  lib,
  ...
}:
{
  flake.modules = {
    homeManager.desktop =
      { pkgs, ... }:
      {
        nixpkgs.overlays = [
          (final: prev: {
            master = import inputs.nixpkgs-master {
              inherit (final) config system;
            };
          })
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

                pkgs.master.vscode-extensions.github.copilot
                pkgs.master.vscode-extensions.github.copilot-chat

                pkgs.vscode-extensions.github.github-vscode-theme
                pkgs.vscode-extensions.github.vscode-pull-request-github
                pkgs.vscode-extensions.golang.go
                pkgs.vscode-extensions.jebbs.plantuml
                pkgs.vscode-extensions.jkillian.custom-local-formatters
                pkgs.vscode-extensions.jnoortheen.nix-ide
                pkgs.vscode-extensions.mkhl.direnv
                pkgs.vscode-extensions.mongodb.mongodb-vscode

                pkgs.master.vscode-extensions.ms-python.debugpy
                pkgs.master.vscode-extensions.ms-python.mypy-type-checker
                pkgs.master.vscode-extensions.ms-python.python
                pkgs.master.vscode-extensions.ms-python.vscode-pylance

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

                pkgs.master.vscode-extensions.visualjj.visualjj

                pkgs.vscode-extensions.yzhang.markdown-all-in-one
                pkgs.vscode-extensions.zhuangtongfa.material-theme
              ];
              userSettings = {
                "[go]" = {
                  "editor.defaultFormatter" = "golang.go";
                };
                "[json]" = {
                  "editor.defaultFormatter" = "vscode.json-language-features";
                };
                "[jsonc]" = {
                  "editor.defaultFormatter" = "vscode.json-language-features";
                };
                "[markdown]" = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                };
                "[nix]" = {
                  "editor.defaultFormatter" = "jkillian.custom-local-formatters";
                };
                "[php]" = {
                  "editor.defaultFormatter" = "bmewburn.vscode-intelephense-client";
                };
                "[toml]" = {
                  "editor.defaultFormatter" = "tamasfe.even-better-toml";
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
                    "command" = "${lib.getExe pkgs.typstyle} -i \${file}";
                    "languages" = [ "typst" ];
                  }
                  {
                    "command" = "${lib.getExe pkgs.nixfmt-rfc-style} \${file}";
                    "languages" = [ "nix" ];
                  }
                ];
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
                "extensions.autoCheckUpdates" = true;
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
                "nix.formatterPath" = lib.getExe pkgs.nixfmt-rfc-style;
                "nix.serverPath" = lib.getExe pkgs.nixd;
                "nix.enableLanguageServer" = true;
                "nix.serverSettings".nixd.formatting.command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
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
}
