# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1](https://github.com/TomasBagdanavicius/firstile-css/releases/tag/v0.1.1) - 2024-11-01

### Added

- New mixin `@apply-module-option`, which can include a single option property from a given component's module.
- Other minor additions.

### Changed

- Replaced the deprecated `darken()` and `lighten()` color functions with the recommended `color.scale()` solution. This can lead to different color output, but since the deprecated functions were used in niche scenarios (eg. for active mode colors), this should be acceptable. Also, `color.scale()` might produce `rgb()` function values with long decimals, but in the minified output it should be converted to hex format.
- Specified exact version numbers for the dev-dependencies in the [package.json](package.json) file.
- Dropped the `unquote()` function wrapper for the common `$layer-list` variable's value. Testing showed that the list of layers is produced without quotes in the [layer-list.scss](./src/partials/layer-list.scss) file.
- [prepare-release.sh](./scripts/prepare-release.sh) script can now update version definition inside the [package.json](package.json) file.
- Added namespace prefixes to global built-in functions that were used in the project, eg. `unquote()` -> `string.unquote()`.
- Other minor changes.

## [0.1.0](https://github.com/TomasBagdanavicius/firstile-css/releases/tag/v0.1.0) - 2024-09-01

### Added

- First release files.