{
  writeShellApplication,
  gh,
  gitMinimal,
  nvd,
  ...
}:
writeShellApplication {
  name = "gh-flake-update";
  runtimeInputs = [
    gh
    gitMinimal
    nvd
  ];
  text = builtins.readFile ./script.sh;
}
