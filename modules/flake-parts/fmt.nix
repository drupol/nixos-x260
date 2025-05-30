{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        nixfmt.enable = true;
        prettier.enable = true;
        rustfmt.enable = true;
        shfmt.enable = true;
        yamlfmt.enable = true;
      };
      settings = {
        on-unmatched = "fatal";
        global.excludes = [
          "*.envrc"
          ".editorconfig"
          "*.directory"
          "*.face"
          "*.fish"
          "*.png"
          "*.toml"
          "*.svg"
          "*.xml"
          "*/.gitignore"
          "_to_migrate/*"
          "LICENSE"
        ];
      };
    };
    pre-commit.settings.hooks.nix-fmt = {
      enable = true;
      entry = "nix fmt -- --fail-on-change";
    };
  };
}
