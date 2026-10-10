# Contributing

## Development setup

```bash
make setup       # installs toolchains expected by the Makefile
make check-deps
```

## Branch naming

- `feat/<short-name>`
- `fix/<short-name>`
- `chore/<short-name>`
- `docs/<short-name>`
- `ci/<short-name>`

## Commits

Conventional Commits: `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`, `test:`, `ci:`.

## Tests

```bash
make lint
make test        # Go + React
make ci-local    # lint + test
make terraform-validate
```

## Pull requests

Open against `main`. CI must be green. Squash merge preferred.

Checklist:

- [ ] `make ci-local` passes
- [ ] Terraform modules still validate
- [ ] Branch naming follows convention
- [ ] Conventional commits
- [ ] Apps under `apps/` keep health tests green when touched
