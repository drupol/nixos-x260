{
  flake.modules = {
    homeManager.dev =
      { pkgs, ... }:
      {
        programs = {
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
                prsLimit = 25;
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
                    key = "V";
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
          gh = {
            extensions = [
              pkgs.gh-dash
            ];
          };
        };
      };
  };
}
