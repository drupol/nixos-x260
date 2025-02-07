{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.git;
in
{
  imports = [ ];

  options = {
    git.enable = lib.mkEnableOption "git and friends";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      gh = {
        enable = true;
        extensions = [
          pkgs.gh-copilot
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
      lazygit = {
        enable = true;
        settings = {
          git.overrideGpg = true;
        };
      };
      git = {
        enable = true;
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
          bump = ''!sh -c 'git commit -am "Version bump v$1" && git psuoc && git release $1' -'';
          release = "!sh -c 'git tag v$1 && git pst' -";
          unrelease = "!sh -c 'git tag -d v$1 && git pso :v$1' -";
          merged = "!sh -c 'git o master && git plom && git bd $1 && git rpo' -";
          aliases = "!git config -l | grep alias | cut -c 7-";
          snap = "!git stash save 'snapshot = $(date)' && git stash apply 'stash@{0}'";
          bare = "!sh -c 'git symbolic-ref HEAD refs/heads/$1 && git rm --cached -r . && git clean -xfd' -";
          whois = ''!sh -c 'git log -i -1 --author="$1" --pretty="format:%an <%ae>"' -'';
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
          branch = {
            autosetuprebase = "always";
          };
          color = {
            ui = "auto";
          };
          core = {
            autocrlf = "input";
            editor = "micro";
            safecrlf = "warn";
            excludesfile = "~/.gitignore_global";
          };
          diff = {
            mnemonicprefix = true;
          };
          include = {
            path = "~/.gitconfig.local";
          };
          init = {
            defaultBranch = "main";
          };
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
          rerere = {
            enabled = true;
          };
          sequence = {
            editor = "code --wait";
          };
          signing = {
            signByDefault = true;
            key = "0AAF2901E8040715";
          };
          commit = {
            gpgsign = true;
          };
        };
      };
      jujutsu = {
        enable = true;
        settings = {
          user = {
            email = "pol.dellaiera@protonmail.com";
            name = "Pol Dellaiera";
          };
          ui = {
            default-command = "log";
            diff-editor = ":builtin";
            graph.style = "square";
            pager = "less -FRX"; # default includes -X, which prevents cleanup
            paginate = "auto";
          };
          git = {
            auto-local-branch = true;
            fetch = [
              "origin"
            ];
          };
          template-aliases = {
            "format_short_id(id)" = "id.shortest()";
          };
          revset-aliases = {
            "immutable_heads()" = "trunk() | tags() | remote_bookmarks(remote=origin)";
          };
          revsets.log = "@ | ancestors(reachable(@, mutable()))";
          snapshot.max-new-file-size = "15M";

          aliases = {
            ll = [
              "log"
              "-r"
              "@ | ancestors(reachable(@ | mine(), mutable())) | trunk()"
            ];
            xl = [
              "log"
              "-r"
              "all()"
            ];
            evolve = [
              "rebase"
              "--skip-empty"
              "-d"
              "main"
            ];
          };
        };
      };
    };
  };
}
