# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0]

### Added

- `CornerClamp` enum with two radius-clamping modes:
  - `.strict` (default): each corner is capped at `min(width, height) / 2`, and adjacent corners are scaled proportionally so the shape stays safe and symmetric.
  - `.relaxed`: each corner can grow up to `min(width, height)`, enabling oversized single-side corners (leaf / "D" shapes). Adjacent-edge conflicts are resolved locally per edge.
- `clamp` parameter on the `AnyCornerShape` initializers and the `anyCornerShape(...)` view modifiers (defaults to `.strict`).

### Notes

- The `clamp` addition is backward compatible; existing call sites keep the previous strict behavior unchanged.

[Unreleased]: https://github.com/JACKCRING/AnyCornerShape/compare/1.0.0...HEAD
[1.0.0]: https://github.com/JACKCRING/AnyCornerShape/releases/tag/1.0.0
