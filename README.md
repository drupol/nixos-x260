[![GitHub Workflow Status][github workflow status]][2]
 ![GitHub stars][github stars]
 ![License][mit]
 [![Donate!][donate github]][5]

# Nix (dotfiles) configurations

This repository contains the configuration of my local network at home.

## Upgrade manually

```shell
sudo nixos-rebuild switch --upgrade-all --flake github:drupol/nixos-x260 -v --refresh
```

[github stars]: https://img.shields.io/github/stars/drupol/nixos-x260.svg?style=flat-square
[github workflow status]: https://img.shields.io/github/actions/workflow/status/drupol/nixos-x260/check.yaml?branch=master&style=flat-square
[license]: https://img.shields.io/packagist/l/loophp/collection.svg?style=flat-square
[donate github]: https://img.shields.io/badge/Sponsor-Github-brightgreen.svg?style=flat-square
[7]: https://packagist.org/?query=collection
[2]: https://github.com/loophp/collection/actions
[mit]: https://img.shields.io/badge/License-MIT-green?style=flat-square
[5]: https://github.com/sponsors/drupol
