# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-10-10

### Added

- MIT license, security policy, Dependabot, and changelog
- Go unit tests for claims-api health handlers
- TFLint in CI for Terraform environments

### Changed

- CI runs real Go tests, npm build/test, and Terraform fmt/validate/tflint without failure masking
- Bumped Go, Node, Terraform, provider, Kubernetes, and GitHub Actions versions to current supported releases
- README aligned with the repository layout and Make targets

### Removed

- Failure masking on CI test and check steps (`|| true`, `|| echo`, `continue-on-error` on checks)
