# CI images

## te-server dependencies (`te-dep-3.12-pp32-lock2-amd64`, `te-dep-3.12-pp32-lock2-arm64`)

`public.ecr.aws/lambda/python:3.12` with te-server's OS packages and its hashed, pinned Python
lockfile installed, one image per architecture:

- `ghcr.io/mazoea/docker-te-deps:te-dep-3.12-pp32-lock2-amd64`
- `ghcr.io/mazoea/docker-te-deps:te-dep-3.12-pp32-lock2-arm64`

`assets/requirements.txt` and `assets/requirements-os.txt` are byte-for-byte copies of te-server's
`requirements.txt` and `requirements-os.txt`. The image keeps them in `/opt/te-deps/`, and te-server's
CI checks that its `requirements.txt` is the same as the one in both images.

When te-server re-locks:
1. Copy te-server's `requirements.txt` and `requirements-os.txt` to `assets/` (no edits).
2. Bump the tag in `scripts/update.tag.bat` (`-lock` -> `-lock2` -> ...), merge, then run it.
   The tag push builds both images natively (`ubuntu-24.04` / `ubuntu-24.04-arm`) and publishes
   them. A new tag keeps the images te-server's base branch still references unchanged until the
   re-lock PR there (which bumps the tags) is merged.

Pull requests build and smoke-test both images without publishing them.
